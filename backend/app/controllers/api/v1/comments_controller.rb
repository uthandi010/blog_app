module Api
  module V1
    class CommentsController < ApplicationController
      before_action :set_blog_post, only: [:create]
      before_action :set_comment, only: %i[update destroy]
      before_action :authorize_comment_owner, only: %i[update destroy]

      def create
        @comment = @blog_post.comments.new(comment_params)
        @comment.user = current_user

        if @comment.save
          render json: @comment, status: :created
        else
          render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @comment.update(comment_params)
          render json: @comment, status: :ok
        else
          render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @comment.destroy
        head :no_content
      end

      private

      def set_blog_post
        @blog_post = BlogPost.find(params[:comment][:blog_post_id])
      end

      def set_comment
        @comment = Comment.find(params[:id])
      end

      def authorize_comment_owner
        return if @comment.user == current_user

        render json: { error: 'You are not authorized to perform this action.' }, status: :forbidden
      end

      def comment_params
        params.require(:comment).permit(:body, :parent_id,:user_id)
      end
    end
  end
end