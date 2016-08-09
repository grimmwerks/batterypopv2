class CreatePollQuestions < ActiveRecord::Migration
  def change
    create_table :poll_questions do |t|
      t.string :title
      t.text :description
      t.integer :order
      t.references :poll, index: true
	t.string :image_file_name
    t.string :image_content_type
    t.integer :image_file_size
    t.datetime :image_updated_at
      t.timestamps
    end
  end
end
