class AddImageOffsetsToPollQuestions < ActiveRecord::Migration
  def change
    add_column :poll_questions, :offset_x, :integer
    add_column :poll_questions, :offset_y, :integer
  end
end
