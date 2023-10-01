class ContactsController < ApplicationController
  respond_to :json
  before_action :set_contact, only: %i[ show update destroy ]
  before_action :authenticate_user!

  def index
    @contacts = current_user.contacts
    render json: @contacts, status: :ok
  end

  def show
  end

  def create
    address = contact_params[:address].to_s
    geocoder = Geokit::Geocoders::GoogleGeocoder
    geocoder.api_key = 'AIzaSyDx8Iwc6lupBGsj325xV_E5fHAojFfhjMc'
    location = geocoder.geocode(address)
  
    @contact = Contact.new(contact_params.merge(user_id: current_user.id))

    if location.success
      @contact.address["latitude"] = location.lat.to_s
      @contact.address["longitude"] = location.lng.to_s
    end
    
  
    if @contact.save
      render json: @contact, status: :created
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end
  

  def update
    address = contact_params[:address].to_s
    geocoder = Geokit::Geocoders::GoogleGeocoder
    geocoder.api_key = 'AIzaSyDx8Iwc6lupBGsj325xV_E5fHAojFfhjMc'
    location = geocoder.geocode(address)
  
    if location.success
      @contact.address["latitude"] = location.lat.to_s
      @contact.address["longitude"] = location.lng.to_s
      @contact.save!
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

  private
    def set_contact
      @contact = Contact.find(params[:id])
    end

    def contact_params
      params.require(:contact).permit(:name, :cpf, :phone, address: [:street, :number, :complement, :neighborhood, :city, :state, :country, :zipcode, :latitude, :longitude])
    end
end
