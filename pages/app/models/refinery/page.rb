# Encoding: utf-8
<<<<<<< HEAD
require 'refinerycms-core'
require 'acts_as_indexed'
require 'friendly_id'
=======
require 'friendly_id'
require 'refinery/core/base_model'
require 'refinery/pages/url'
>>>>>>> 2-1-main

module Refinery
  class Page < Core::BaseModel
    extend FriendlyId

    translates :title, :menu_title, :custom_slug, :slug, :include => :seo_meta

    class Translation
      is_seo_meta
<<<<<<< HEAD
      attr_accessible :browser_title, :meta_description, :meta_keywords
    end

    attr_accessible :title
=======
      attr_accessible *::SeoMeta.attributes.keys, :locale
    end
>>>>>>> 2-1-main

    # Delegate SEO Attributes to globalize translation
    seo_fields = ::SeoMeta.attributes.keys.map{|a| [a, :"#{a}="]}.flatten
    delegate(*(seo_fields << {:to => :translation}))

    attr_accessible :id, :deletable, :link_url, :menu_match,
                    :skip_to_first_child, :position, :show_in_menu, :draft,
<<<<<<< HEAD
                    :parts_attributes, :browser_title, :meta_description,
                    :parent_id, :menu_title, :page_id, :layout_template,
                    :view_template, :custom_slug, :slug
=======
                    :parts_attributes, :parent_id, :menu_title, :page_id,
                    :layout_template, :view_template, :custom_slug, :slug,
                    :title, *::SeoMeta.attributes.keys
>>>>>>> 2-1-main

    validates :title, :presence => true

    validates :custom_slug, :uniqueness => true, :allow_blank => true

    # Docs for acts_as_nested_set https://github.com/collectiveidea/awesome_nested_set
    # rather than :delete_all we want :destroy
    acts_as_nested_set :dependent => :destroy

    # Docs for friendly_id http://github.com/norman/friendly_id
    friendly_id_options = {:use => [:reserved, :globalize], :reserved_words => %w(index new session login logout users refinery admin images wymiframe)}
    if ::Refinery::Pages.scope_slug_by_parent
      friendly_id_options[:use] << :scoped
      friendly_id_options.merge!(:scope => :parent)
    end

    friendly_id :custom_slug_or_title, friendly_id_options

    has_many :parts,
             :foreign_key => :refinery_page_id,
             :class_name => '::Refinery::PagePart',
             :order => 'position ASC',
             :inverse_of => :page,
             :dependent => :destroy,
             :include => ((:translations) if ::Refinery::PagePart.respond_to?(:translation_class))

    accepts_nested_attributes_for :parts, :allow_destroy => true

    before_save do |m|
      m.translation.globalized_model = self
      m.translation.save if m.translation.new_record?
    end
    before_create :ensure_locale!
    before_destroy :deletable?
<<<<<<< HEAD
    after_save :reposition_parts!, :expire_page_caching
    after_destroy :expire_page_caching
=======
    after_save :reposition_parts!
>>>>>>> 2-1-main

    class << self
      # Live pages are 'allowed' to be shown in the frontend of your website.
      # By default, this is all pages that are not set as 'draft'.
      def live
        where(:draft => false)
      end

      # Find page by path, checking for scoping rules
      def find_by_path(path)
<<<<<<< HEAD
        split_path = path.to_s.split('/').reject(&:blank?)
        page = ::Refinery::Page.by_slug(split_path.shift, :parent_id => nil).first
        page = page.children.by_slug(split_path.shift).first until page.nil? || split_path.empty?
=======
        if ::Refinery::Pages.scope_slug_by_parent
          # With slugs scoped to the parent page we need to find a page by its full path.
          # For example with about/example we would need to find 'about' and then its child
          # called 'example' otherwise it may clash with another page called /example.
          path = path.split('/').select(&:present?)
          page = by_slug(path.shift, :parent_id => nil).first
          while page && path.any? do
            slug_or_id = path.shift
            page = page.children.by_slug(slug_or_id).first || page.children.find(slug_or_id)
          end
        else
          page = by_slug(path).first
        end
>>>>>>> 2-1-main

        page
      end

      # Helps to resolve the situation where you have a path and an id
      # and if the path is unfriendly then a different finder method is required
      # than find_by_path.
      def find_by_path_or_id(path, id)
        if path.present?
          if path.friendly_id?
            find_by_path(path)
          else
            find(path)
          end
        elsif id.present?
          find(id)
        end
      end

      # Finds pages by their title.  This method is necessary because pages
      # are translated which means the title attribute does not exist on the
      # pages table thus requiring us to find the attribute on the translations table
      # and then join to the pages table again to return the associated record.
      def by_title(title)
        with_globalize(:title => title)
      end

<<<<<<< HEAD
      # Finds pages by their slug.  See by_title
      def by_slug(slug, conditions={})
        locales = Refinery.i18n_enabled? ? Refinery::I18n.frontend_locales.map(&:to_s) : ::I18n.locale.to_s
        with_globalize({ :locale => locales, :slug => slug }.merge(conditions))
=======
      # Finds pages by their slug.  This method is necessary because pages
      # are translated which means the slug attribute does not exist on the
      # pages table thus requiring us to find the attribute on the translations table
      # and then join to the pages table again to return the associated record.
      def by_slug(slug, conditions={})
        with_globalize({
          :locale => Refinery::I18n.frontend_locales.map(&:to_s),
          :slug => slug
        }.merge(conditions))
>>>>>>> 2-1-main
      end

      # Shows all pages with :show_in_menu set to true, but it also
      # rejects any page that has not been translated to the current locale.
      # This works using a query against the translated content first and then
      # using all of the page_ids we further filter against this model's table.
      def in_menu
        where(:show_in_menu => true).with_globalize
      end

      # An optimised scope containing only live pages ordered for display in a menu.
      def fast_menu
        live.in_menu.order(arel_table[:lft]).includes(:parent, :translations)
      end

      # Wrap up the logic of finding the pages based on the translations table.
      def with_globalize(conditions = {})
        conditions = {:locale => ::Globalize.locale.to_s}.merge(conditions)
<<<<<<< HEAD
        globalized_conditions = {}
=======
        translations_conditions = {}
        translated_attrs = translated_attribute_names.map(&:to_s) | %w(locale)

>>>>>>> 2-1-main
        conditions.keys.each do |key|
          if translated_attrs.include? key.to_s
            translations_conditions["#{self.translation_class.table_name}.#{key}"] = conditions.delete(key)
          end
        end

        # A join implies readonly which we don't really want.
        where(conditions).joins(:translations).where(translations_conditions).
                                               readonly(false)
      end

      # Returns how many pages per page should there be when paginating pages
      def per_page(dialog = false)
        dialog ? Pages.pages_per_dialog : Pages.pages_per_admin_index
      end

      def rebuild_with_slug_nullification!
        rebuild_without_slug_nullification!
        nullify_duplicate_slugs_under_the_same_parent!
      end
      alias_method_chain :rebuild!, :slug_nullification

      protected
      def nullify_duplicate_slugs_under_the_same_parent!
        t_slug = translation_class.arel_table[:slug]
        joins(:translations).group(:locale, :parent_id, t_slug).having(t_slug.count.gt(1)).count.
        each do |(locale, parent_id, slug), count|
          by_slug(slug, :locale => locale).where(:parent_id => parent_id).drop(1).each do |page|
            page.slug = nil # kill the duplicate slug
            page.save # regenerate the slug
          end
        end
      end
    end

    def translated_to_default_locale?
<<<<<<< HEAD
      persisted? && (!Refinery.i18n_enabled? || translations.where(:locale => Refinery::I18n.default_frontend_locale).any?)
=======
      persisted? && translations.where(:locale => Refinery::I18n.default_frontend_locale).any?
>>>>>>> 2-1-main
    end

    # The canonical page for this particular page.
    # Consists of:
    #   * The default locale's translated slug
    def canonical
<<<<<<< HEAD
      Globalize.with_locale(Refinery.i18n_enabled? && Refinery::I18n.default_frontend_locale || ::I18n.locale) { url }
=======
      Globalize.with_locale(::Refinery::I18n.default_frontend_locale) { url }
>>>>>>> 2-1-main
    end

    # The canonical slug for this particular page.
    # This is the slug for the default frontend locale.
    def canonical_slug
<<<<<<< HEAD
      Globalize.with_locale(Refinery.i18n_enabled? && Refinery::I18n.default_frontend_locale || ::I18n.locale) { slug }
=======
      Globalize.with_locale(::Refinery::I18n.default_frontend_locale) { slug }
>>>>>>> 2-1-main
    end

    # Returns in cascading order: custom_slug or menu_title or title depending on
    # which attribute is first found to be present for this page.
    def custom_slug_or_title
<<<<<<< HEAD
      custom_slug.presence || menu_title.presence || title
=======
      custom_slug.presence || menu_title.presence || title.presence
>>>>>>> 2-1-main
    end

    # Am I allowed to delete this page?
    # If a link_url is set we don't want to break the link so we don't allow them to delete
    # If deletable is set to false then we don't allow this page to be deleted. These are often Refinery system pages
    def deletable?
      deletable && link_url.blank? && menu_match.blank?
    end

    # Repositions the child page_parts that belong to this page.
    # This ensures that they are in the correct 0,1,2,3,4... etc order.
    def reposition_parts!
      reload.parts.each_with_index do |part, index|
        part.update_attributes :position => index
      end
    end

    # Before destroying a page we check to see if it's a deletable page or not
    # Refinery system pages are not deletable.
    def destroy
      return super if deletable?

      puts_destroy_help

      false
    end

    # If you want to destroy a page that is set to be not deletable this is the way to do it.
    def destroy!
      self.menu_match = nil
      self.link_url = nil
      self.deletable = true

      destroy
    end

    # Used for the browser title to get the full path to this page
    # It automatically prints out this page title and all of it's parent page titles joined by a PATH_SEPARATOR
    def path(options = {})
      # Override default options with any supplied.
      options = {:reversed => true}.merge(options)

      if parent_id
        parts = [title, parent.path(options)]
        parts.reverse! if options[:reversed]
        parts.join(' - ')
      else
        title
      end
    end

    def url
      Pages::Url.build(self)
    end

    def link_url_localised?
      Refinery.deprecate "Refinery::Page#link_url_localised?", :when => '2.2',
                         :replacement => "Refinery::Pages::Url::Localised#url"
      Pages::Url::Localised.new(self).url
    end

<<<<<<< HEAD
    # Add 'marketable url' attributes into this page's url.
    # This sets 'path' as the nested_url value and sets 'id' to nil.
    # For example, this might evaluate to /about for the "About" page.
    def url_marketable
      # :id => nil is important to prevent any other params[:id] from interfering with this route.
      url_normal.merge :path => nested_url, :id => nil
=======
    def url_normal
      Refinery.deprecate "Refinery::Page#url_normal", :when => '2.2',
                         :replacement => "Refinery::Pages::Url::Normal#url"
      Pages::Url::Normal.new(self).url
>>>>>>> 2-1-main
    end

    def url_marketable
      Refinery.deprecate "Refinery::Page#url_marketable", :when => '2.2',
                         :replacement => "Refinery::Pages::Url::Marketable#url"
      Pages::Url::Marketable.new(self).url
    end

<<<<<<< HEAD
    # If the current locale is set to something other than the default locale
    # then the :locale attribute will be set on the url hash, otherwise it won't be.
    def with_locale_param(url_hash, locale = nil)
      locale ||= ::Refinery::I18n.current_frontend_locale if self.class.different_frontend_locale?
      url_hash.update :locale => locale if locale
      url_hash
=======
    def nested_url
      globalized_slug = Globalize.with_locale(slug_locale) { to_param.to_s }
      if ::Refinery::Pages.scope_slug_by_parent
        [parent.try(:nested_url), globalized_slug].compact.flatten
      else
        [globalized_slug]
      end
>>>>>>> 2-1-main
    end

    def uncached_nested_url
      [
        parent.try(:uncached_nested_url),
        Globalize.with_locale(slug_locale) { to_param.to_s }
      ].compact.flatten
    end

    # Returns an array with all ancestors to_param, allow with its own
    # Ex: with an About page and a Mission underneath,
    # ::Refinery::Page.find('mission').nested_url would return:
    #
    #   ['about', 'mission']
    #
<<<<<<< HEAD
    alias_method :nested_url, :uncached_nested_url

    # Returns the string version of nested_url, i.e., the path that should be generated
    # by the router
    def nested_path
      Rails.cache.fetch(path_cache_key) { ['', nested_url].join('/') }
    end

    def path_cache_key(locale = Globalize.locale)
      [cache_key(locale), 'nested_path'].join('#')
    end

    def url_cache_key(locale = Globalize.locale)
      [cache_key(locale), 'nested_url'].join('#')
    end

    def cache_key(locale)
      [Refinery::Core.base_cache_key, 'page', locale, id].compact.join('/')
=======
    alias_method :uncached_nested_url, :nested_url

    # Returns the string version of nested_url, i.e., the path that should be
    # generated by the router
    def nested_path
      ['', nested_url].join('/')
>>>>>>> 2-1-main
    end

    # Returns true if this page is "published"
    def live?
      !draft?
    end

    # Return true if this page can be shown in the navigation.
    # If it's a draft or is set to not show in the menu it will return false.
    def in_menu?
      live? && show_in_menu?
    end

    def not_in_menu?
      !in_menu?
    end

    # Returns all visible sibling pages that can be rendered for the menu
    def shown_siblings
      siblings.reject(&:not_in_menu?)
    end

    def to_refinery_menu_item
      {
        :id => id,
        :lft => lft,
        :depth => depth,
        :menu_match => menu_match,
        :parent_id => parent_id,
        :rgt => rgt,
        :title => menu_title.presence || title.presence,
        :type => self.class.name,
        :url => url
      }
    end

    # Accessor method to get a page part from a page.
    # Example:
    #
    #    ::Refinery::Page.first.content_for(:body)
    #
    # Will return the body page part of the first page.
    def content_for(part_title)
      part_with_title(part_title).try(:body)
    end

    # Accessor method to test whether a page part
    # exists and has content for this page.
    # Example:
    #
    #   ::Refinery::Page.first.content_for?(:body)
    #
    # Will return true if the page has a body page part and it is not blank.
    def content_for?(part_title)
      content_for(part_title).present?
    end

    # Accessor method to get a page part object from a page.
    # Example:
    #
    #    ::Refinery::Page.first.part_with_title(:body)
    #
    # Will return the Refinery::PagePart object with that title using the first page.
    def part_with_title(part_title)
      # self.parts is usually already eager loaded so we can now just grab
      # the first element matching the title we specified.
      self.parts.detect do |part|
        part.title.present? and # protecting against the problem that occurs when have nil title
        part.title == part_title.to_s or
        part.title.downcase.gsub(" ", "_") == part_title.to_s.downcase.gsub(" ", "_")
      end
    end

<<<<<<< HEAD
    # Used to index all the content on this page so it can be easily searched.
    def all_page_part_content
      parts.map(&:body).join(" ")
=======
  private

    # Make sures that a translation exists for this page.
    # The translation is set to the default frontend locale.
    def ensure_locale!
      if self.translations.empty?
        self.translations.build(:locale => Refinery::I18n.default_frontend_locale)
      end
>>>>>>> 2-1-main
    end

    # Protects generated slugs from title if they are in the list of reserved words
    # This applies mostly to plugin-generated pages.
    # This only kicks in when Refinery::Pages.marketable_urls is enabled.
    # Also check for global scoping, and if enabled, allow slashes in slug.
    #
    # Returns the sluggified string
    def normalize_friendly_id_with_marketable_urls(slug_string)
      # If we are scoping by parent, no slashes are allowed. Otherwise, slug is potentially
      # a custom slug that contains a custom route to the page.
      if !Pages.scope_slug_by_parent && slug_string.include?('/')
        slug_string.sub!(%r{^/*}, '').sub!(%r{/*$}, '') # Remove leading and trailing slashes, but allow internal
        slug_string.split('/').select(&:present?).map {|s| normalize_friendly_id_with_marketable_urls(s) }.join('/')
      else
        sluggified = slug_string.to_slug.normalize!
        if Pages.marketable_urls && self.class.friendly_id_config.reserved_words.include?(sluggified)
          sluggified << "-page"
        end
        sluggified
      end
    end
    alias_method_chain :normalize_friendly_id, :marketable_urls

<<<<<<< HEAD
    private

    # Make sures that a translation exists for this page.
    # The translation is set to the default frontend locale.
    def ensure_locale
      if self.translations.empty?
        self.translations.build :locale => ::Refinery::I18n.default_frontend_locale
      end
    end
=======
    def puts_destroy_help
      puts "This page is not deletable. Please use .destroy! if you really want it deleted "
      puts "unset .link_url," if link_url.present?
      puts "unset .menu_match," if menu_match.present?
      puts "set .deletable to true" unless deletable
    end

    def slug_locale
      return Globalize.locale if translation_for(Globalize.locale).try(:slug).present?
>>>>>>> 2-1-main

      if translations.empty? || translation_for(Refinery::I18n.default_frontend_locale).present?
        Refinery::I18n.default_frontend_locale
      else
        translations.first.locale
      end
    end

    def slug_locale
      return Globalize.locale if translation_for(Globalize.locale).try(:slug).present?

      if Refinery.i18n_enabled? && (translations.empty? || translation_for(Refinery::I18n.default_frontend_locale).present?)
        Refinery::I18n.default_frontend_locale
      else
        translations.first.locale
      end
    end
  end
end
