module Api
  module V1
    class LikesController < ApplicationController
      def create
        blog_post = BlogPost.find(params[:blog_post_id])
        like = blog_post.likes.new(user: current_user)

        if like.save
          render json: { message: 'Liked successfully', likes_count: blog_post.likes.count }, status: :created
        else
          render json: { error: like.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        like = Like.find_by(blog_post_id: params[:blog_post_id], user: current_user)

        if like&.destroy
          render json: { message: 'Unliked successfully', likes_count: BlogPost.find(params[:blog_post_id]).likes.count }, status: :ok
        else
          render json: { error: 'Unable to unlike' }, status: :unprocessable_entity
        end
      end
    end
  end
end