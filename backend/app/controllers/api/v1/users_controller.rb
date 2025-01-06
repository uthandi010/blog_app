module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :current_user, only: %i[create]
      
      def create
        @user = User.new(user_params)   
        member_role = Role.find_by(name: 'MEMBER')
        @user.role = member_role if member_role
        if @user.save
          render json: { message: "Welcome, #{@user.firstname}!", user: @user }, status: :created
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :firstname, :lastname)
      end
    end
  end
end