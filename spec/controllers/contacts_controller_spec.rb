require 'rails_helper'

require 'byebug'

RSpec.describe ContactsController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do
    @user = User.create(name: 'Test User', email: 'teste@teste.com', password: 'password')

    sign_in @user
  end

  subject(:valid_attributes) do
    {
      name: 'Test Contact',
      cpf: '88734343040',
      phone: '1234567890',
      address: {
        street: 'Test Street',
        number: '123',
        complement: 'Test Complement',
        neighborhood: 'Test Neighborhood',
        city: 'Test City',
        state: 'Test State',
        country: 'Test Country',
        zipcode: '12345678',
        latitude: -23.550520,
        longitude: -46.633308
      }
    }
  end

  describe 'POST create' do
    context 'with valid attributes' do
      it 'creates a new contact' do
        expect {
          post :create, params: { contact: valid_attributes }
        }.to change(Contact, :count).by(1)
      end

      it 'renders a JSON response with the new contact' do
        post :create, params: { contact: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(JSON.parse(response.body).keys).to include('id', 'name', 'cpf', 'phone', 'address', 'created_at', 'updated_at')
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new contact in the database' do
        expect {
          post :create, params: { contact: { name: '' } }
        }.not_to change(Contact, :count)
      end

      it 'renders a JSON response with errors for the new contact' do
        post :create, params: { contact: { name: '', cpf: '88734343040', phone: '1234567890', address: { "zipcode": "81470266"} } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(JSON.parse(response.body)['name']).to include("can't be blank")
      end
    end
  end

  describe 'GET index' do
    it 'renders a successful response' do
        Contact.create(valid_attributes)
        get :index, params: {}
        expect(response).to be_successful
    end
  end

  describe 'PUT update' do
    before(:each) do
      @contact = Contact.create(valid_attributes.merge(user_id: @user.id))
    end

    it 'updates the requested contact' do
      put :update, params: { id: @contact.id, contact: { name: 'New Name' } }
      @contact.reload
      expect(@contact.name).to eq('New Name')
    end

    it 'renders a JSON response with the contact' do
      put :update, params: { id: @contact.id, contact: valid_attributes }
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'renders a JSON response with errors for the contact' do
      put :update, params: { id: @contact.id, contact: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)['name']).to include("can't be blank")
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested contact' do
      @contact = Contact.create(valid_attributes.merge(user_id: @user.id))
      expect {
        delete :destroy, params: { id: @contact.id }
      }.to change(Contact, :count).by(-1)
    end
  end
end
