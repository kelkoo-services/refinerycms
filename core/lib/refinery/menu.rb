module Refinery
  class Menu

    def initialize(objects = nil)
<<<<<<< HEAD
      objects.each do |item|
        item = item.to_refinery_menu_item if item.respond_to?(:to_refinery_menu_item)
        items << MenuItem.new(item.merge(:menu => self))
      end if objects
    end

    attr_accessor :items
=======
       append(objects)
    end

    def append(objects)
      Array(objects).each do |item|
        item = item.to_refinery_menu_item if item.respond_to?(:to_refinery_menu_item)
        items << MenuItem.new(self, item)
      end
    end
>>>>>>> 2-1-main

    attr_accessor :items

    def items
      @items ||= []
    end

    def roots
      @roots ||= select {|item| item.orphan? && item.depth == minimum_depth }
    end

    def to_s
      map(&:title).join(' ')
    end

<<<<<<< HEAD
    # The delegation is specified so crazily so that it works on 1.8.x and 1.9.x
    delegate *((Array.instance_methods - Object.instance_methods) << {:to => :items})
=======
    delegate :inspect, :map, :select, :detect, :first, :last, :length, :size, :to => :items

    protected
    def minimum_depth
      map(&:depth).min
    end

>>>>>>> 2-1-main
  end
end
