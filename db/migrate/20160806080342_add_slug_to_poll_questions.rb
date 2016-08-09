class AddSlugToPollQuestions < ActiveRecord::Migration
  def change
    add_column :poll_questions, :slug, :string
  end
end
