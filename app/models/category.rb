class Category < ActiveRecord::Base
	has_and_belongs_to_many :episodes, :join_table => :categories_episodes
end
