class AddUserIdAndBlogPostIdToComments < ActiveRecord::Migration[8.0]
  def change
    add_column :comments, :user_id, :integer
    add_column :comments, :blog_post_id, :integer
  end
end
