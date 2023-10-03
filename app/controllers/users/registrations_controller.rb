# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    include RackSessionsFix
    respond_to :json

    def destroy
      current_user.destroy
  
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