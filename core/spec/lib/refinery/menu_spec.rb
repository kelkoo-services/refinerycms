require 'spec_helper'
<<<<<<< HEAD

module Refinery
  describe Menu do

    let(:menu) do
      page1 = FactoryGirl.create(:page, :title => 'test1')
      page2 = FactoryGirl.create(:page, :title => 'test2', :parent_id => page1.id)
      Refinery::Menu.new([page1, page2])
    end

    describe '.initialize' do
      it "returns a collection of menu item objects" do
        menu.each { |item| item.should be_an_instance_of(MenuItem) }
      end
    end

    describe '#items' do
      it 'returns a collection' do
        menu.items.count.should eq(2)
      end
    end

    describe '#roots' do
      it 'returns a collection of items with parent_id == nil' do
        menu.roots.collect(&:parent_id).should eq([nil])
      end
    end

    describe '#to_s' do
      it 'returns string of joined page titles' do
        menu.to_s.should eq('test1 test2')
      end
    end

=======
require 'refinery/menu'
require 'refinery/menu_item'

module Refinery
  describe Menu do
    it 'constructs a menu given items' do
      Menu.new([{:id => 1}, {:id => 2}]).items.each {|item|
        item.should be_kind_of MenuItem
      }
    end

    it 'allows construction of a new menu from this menu' do
      expect {
        Menu.new(Menu.new([{:id => 1}, {:id => 2}]).map.first)
      }.to_not raise_exception
    end

    it '#roots contains only items at the same depth' do
      menu = Menu.new([{:id => 1, :depth => 0, :parent_id => nil},
                        {:id => 2, :depth => 0, :parent_id => nil},
                        {:id => 3, :depth => 1, :parent_id => nil}])
      menu.roots.length.should == 2
      menu.roots.map(&:original_id).should include(1,2)
    end
>>>>>>> 2-1-main
  end
end
