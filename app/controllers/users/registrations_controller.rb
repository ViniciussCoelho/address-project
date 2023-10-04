# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    include RackSessionsFix
    respond_to :json

    def destroy
      password = params[:password]

      if current_user.valid_password?(password) 
        current_user.destroy
      else 
        return render json: { status: { code: 401, message: 'Invalid password.' } }, status: :unauthorized
      end
  
      render json: { status: { code: 200, message: 'User deleted successfully.' } }, status: :ok
    end

    private

    def respond_with(current_user, _opts = {})
      if resource.persisted?
        render json: {
          status: { code: 201, message: 'Signed up successfully.' },
          data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
        }, status: :created
      else
        render json: {
          status: { message: "User couldn't be created successfully. #{current_user.errors.full_messages.to_sentence}" }
        }, status: :unprocessable_entity
      end
    end
  end
end