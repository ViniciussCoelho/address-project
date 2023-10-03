# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
                                  sign_in: 'login',
                                  sign_out: 'logout',
                                  registration: 'signup'
                                  
                                },
                      controllers: {
                        sessions: 'users/sessions',
                        registrations: 'users/registrations'
                      }

  devise_scope :user do
    delete 'delete_user', to: 'users/registrations#destroy'
  end

  resources :contacts
  get 'address_by_zipcode', to: 'contacts#address_by_zipcode'
end