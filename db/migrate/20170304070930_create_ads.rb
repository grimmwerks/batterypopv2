class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.text :content
      t.boolean :active
      # t.references :page, index: true
      t.string :page_slug
      t.timestamps
    end
  end
end
