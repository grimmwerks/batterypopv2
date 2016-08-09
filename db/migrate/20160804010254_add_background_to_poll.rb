class AddBackgroundToPoll < ActiveRecord::Migration
  def change
  	# add_column :tournaments, :dfp_header_code, :text
	add_column :polls, :background_file_name, :string
    add_column :polls, :background_content_type, :string
    add_column :polls, :background_file_size, :integer
    add_column :polls, :background_updated_at, :datetime
    add_column :polls, :content, :text
  end
end
