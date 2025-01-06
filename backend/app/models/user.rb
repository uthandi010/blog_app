class User < ApplicationRecord
  include Clearance::User

  belongs_to :role
  has_many :blog_posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_blog_posts, through: :likes, source: :blog_post
  
  validates :role, presence: true
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true 
end
