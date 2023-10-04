class ContactsController < ApplicationController
  respond_to :json
  before_action :set_contact, only: %i[ show update destroy ]
  before_action :authenticate_user!

  def index
    @contacts = contact_service.get_contacts(user_id: current_user.id,
                                             page: params[:page],
                                             per_page: params[:per_page],
                                             order: params[:order],
                                             search: params[:search])

    render json: { contacts: @contacts, total_pages: @contacts.total_pages }, status: :ok
  end

  def show
  end

  def create
    geocoding_result = contact_service.geocode_address(contact_params[:address].to_s)

    @contact = Contact.new(contact_params.merge(user_id: current_user.id))

    if geocoding_result[:success]
      @contact.address["latitude"] = geocoding_result[:latitude]
      @contact.address["longitude"] = geocoding_result[:longitude]
    end

    if @contact.save
      render json: @contact, status: :created
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end
  

  def update
    geocoding_result = contact_service.geocode_address(contact_params[:address].to_s)

    if geocoding_result[:success]
      @contact.address["latitude"] = geocoding_result[:latitude]
      @contact.address["longitude"] = geocoding_result[:longitude]
    end
    
    if @contact.update(contact_params)
      render json: @contact, status: :ok
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @contact.destroy

    render json: { status: 200, message: 'Contact deleted successfully.' }, status: :ok
  end

  def address_by_zipcode
    response = contact_service.get_address_by_zipcode(zipcode: params[:address][:zipcode])

    render json: response, status: response[:status]
  end

  private

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:name, :cpf, :phone, address: [:street, :number, :complement, :neighborhood, :city, :state, :country, :zipcode, :latitude, :longitude])
  end

  def contact_service
    @contact_service ||= ContactService.new
  end
end
