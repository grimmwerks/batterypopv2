class PollSceneAndJoinTable < ActiveRecord::Migration
  def change
  	create_table :poll_scenes do |t|
  		t.string :name
  		t.string :image_file_name
    	t.string :image_content_type
    	t.integer :image_file_size
    	t.datetime :image_updated_at
      	t.timestamps
  	end

  	create_table :poll_answers_poll_scenes do |t|
  		t.references :poll_scenes, index: true
  		t.references :poll_answers, index: true
  	end
  end
end
