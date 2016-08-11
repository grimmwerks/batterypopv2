class AddDatetimeToPollAnswersPollScenes < ActiveRecord::Migration
  def change
  	add_column :poll_answers_poll_scenes, :created_at, :datetime
  	add_column :poll_answers_poll_scenes, :updated_at, :datetime
  end
end
