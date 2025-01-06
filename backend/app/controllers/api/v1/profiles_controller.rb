module Api
  module V1
    class ProfilesController < ApplicationController
      def show

        blog_posts = current_user.blog_posts.map do |post|
          {
            id: post.id,
            title: post.title,
            content: post.description,
            image_url: post.image.attached? ? rails_blob_url(post.image) : false,
          }
        end

        render json: { user: current_user, posts: blog_posts }
      end
    end
  end
end
