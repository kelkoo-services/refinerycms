class CreateTableRefineryImageThumb < ActiveRecord::Migration
  def change
    create_table :refinery_images_thumb do |t|
      t.string :job
      t.string :uid
      t.timestamps
    end
  end
end
