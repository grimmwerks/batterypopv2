class ChangePollQuestionData < ActiveRecord::Migration
  def change
  	add_column :poll_questions, :data, :text
  	remove_column :poll_questions, :offset_x
  	remove_column :poll_questions, :offset_y
  end
end
