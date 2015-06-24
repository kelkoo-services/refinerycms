module Refinery
  module Admin
    module PagesHelper
<<<<<<< HEAD
      def parent_id_nested_set_options(current_page = nil)
=======
      def parent_id_nested_set_options(current_page)
>>>>>>> 2-1-main
        pages = []
        nested_set_options(::Refinery::Page, current_page) {|page| pages << page}
        # page.title needs the :translations association, doing something like
        # nested_set_options(::Refinery::Page.includes(:translations), page) doesn't work, yet.
        # See https://github.com/collectiveidea/awesome_nested_set/pull/123
        ActiveRecord::Associations::Preloader.new(pages, :translations).run
        pages.map {|page| ["#{'-' * page.level} #{page.title}", page.id]}
      end

      def template_options(template_type, current_page)
<<<<<<< HEAD
        return {} if current_page.send(template_type)

        if current_page.parent_id?
          # Use Parent Template by default.
          { :selected => current_page.parent.send(template_type) }
        else
          # Use Default Template (First in whitelist)
          { :selected => Refinery::Pages.send("#{template_type}_whitelist").first }
        end
=======
        html_options = { :selected => send("default_#{template_type}", current_page) }

        if (template = current_page.send(template_type).presence)
          html_options.update :selected => template
        elsif current_page.parent_id? && !current_page.send(template_type).presence
          template = current_page.parent.send(template_type).presence
          html_options.update :selected => template if template
        end

        html_options
      end

      def default_view_template(current_page)
        current_page.link_url == "/" ? "home" : "show"
      end

      def default_layout_template(current_page)
        "application"
>>>>>>> 2-1-main
      end

      # In the admin area we use a slightly different title
      # to inform the which pages are draft or hidden pages
      def page_meta_information(page)
        meta_information = ActiveSupport::SafeBuffer.new
        meta_information << content_tag(:span, :class => 'label') do
          ::I18n.t('hidden', :scope => 'refinery.admin.pages.page')
        end unless page.show_in_menu?

        meta_information << content_tag(:span, :class => 'label notice') do
          ::I18n.t('draft', :scope => 'refinery.admin.pages.page')
        end if page.draft?

<<<<<<< HEAD
        meta_information.html_safe
=======
        meta_information
>>>>>>> 2-1-main
      end

      # We show the title from the next available locale
      # if there is no title for the current locale
      def page_title_with_translations(page)
<<<<<<< HEAD
        if page.title.present?
          page.title
        else
          page.translations.detect {|t| t.title.present?}.title
        end
=======
        page.title.presence || page.translations.detect {|t| t.title.present?}.title
>>>>>>> 2-1-main
      end
    end
  end
end
