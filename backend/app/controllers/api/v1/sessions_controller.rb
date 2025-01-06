module Api
  module V1
    class SessionsController < Clearance::SessionsController
      skip_before_action :current_user, only: %i[create]
      
      def create
        user = User.find_by(email: session_params[:email])
        if user&.authenticated?(session_params[:password])
          sign_in(user) do |status|
            if status.success?
              return render json: { notice: 'Signed in successfully!', user: user, remember_token: user.remember_token }, status: :ok
            end
          end
        else
          render json: { alert: 'Invalid email or password.' }, status: :unauthorized
        end
      end

      def destroy
        sign_out
        render json: { notice: 'You have successfully signed out.' }, status: :ok
      end

      private

      def session_params
        params.require(:session).permit(:email, :password)
      end
    end
  end
end
