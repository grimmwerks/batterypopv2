class FixPollAnswersPollScenesJoins < ActiveRecord::Migration
  def change
  	rename_column :poll_answers_poll_scenes, :poll_scenes_id, :poll_scene_id
  	rename_column :poll_answers_poll_scenes, :poll_answers_id, :poll_answer_id
  end
end
