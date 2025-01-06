module Api
  module V1
    class BlogPostsController < ApplicationController
      before_action :set_blog_post, only: %i[show update destroy]

      def index
        @blog_posts = BlogPost.includes(:user, :likes).all
      
        blog_posts_with_images = @blog_posts.map do |blog_post|
          {
            isLiked: blog_post.likes.any? { |like| like.user_id == current_user.id },
            likes: blog_post.likes,
            current_user: current_user,
            id: blog_post.id,
            title: blog_post.title,
            description: blog_post.description,
            image_url: blog_post.image.attached? ? rails_blob_url(blog_post.image) : nil,
            user: {
              id: blog_post.user.id,
              firstname: blog_post.user.firstname,
              lastname: blog_post.user.lastname
            }
          }
        end
      
        render json: { blog_posts: blog_posts_with_images }
      end

      # POST /api/v1/blog_posts
      def create
        @blog_post = current_user.blog_posts.new(blog_post_params)
        if @blog_post.save
          render json: {
            id: @blog_post.id,
            title: @blog_post.title,
            description: @blog_post.description,
            image_url: @blog_post.image.attached? ? rails_blob_url(@blog_post.image) : nil
          }, status: :created
        else
          render json: { errors: @blog_post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/blog_posts/:id
      def show
        @comments = @blog_post.comments.includes(:user).where(parent_id: nil).map do |comment|
          {
            id: comment.id,
            body: comment.body,
            user: {
              id: comment.user.id,
              firstname: comment.user.firstname,
              lastname: comment.user.lastname
            },
            replies: comment.replies.includes(:user).map do |reply|
              {
                id: reply.id,
                body: reply.body,
                user: {
                  id: reply.user.id,
                  firstname: reply.user.firstname,
                  lastname: reply.user.lastname
                }
              }
            end
          }
        end

        render json: {
          post: {
            id: @blog_post.id,
            title: @blog_post.title,
            description: @blog_post.description,
            image_url: @blog_post.image.attached? ? rails_blob_url(@blog_post.image) : nil
          },
          user: {
            id: @blog_post.user.id,
            firstname: @blog_post.user.firstname,
            lastname: @blog_post.user.lastname
          },
          current_user: {
            id: current_user.id,
            firstname: current_user.firstname,
            lastname: current_user.lastname
          },
          comments: @comments
        }
      end

      # PATCH/PUT /api/v1/blog_posts/:id
      def update
        if @blog_post.update(blog_post_params)
          render json: {
            id: @blog_post.id,
            title: @blog_post.title,
            description: @blog_post.description,
            image_url: @blog_post.image.attached? ? rails_blob_url(@blog_post.image) : nil
          }
        else
          render json: { errors: @blog_post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/blog_posts/:id
      def destroy
        @blog_post.destroy
        head :no_content
      end

      private

      def blog_post_params
        params.require(:blog_post).permit(:title, :description, :image)
      end

      def set_blog_post
        @blog_post = BlogPost.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Blog post not found' }, status: :not_found
      end
    end
  end
end
