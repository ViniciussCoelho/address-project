class ContactsController < ApplicationController
  respond_to :json
  before_action :set_contact, only: %i[ show update destroy ]

  def index
    @contacts = Contact.all

    render json: @contacts, status: :ok
  end

  def show
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      render json: @contact, status: :created
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  def update
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
      params.require(:contact).permit(:name, :cpf, :phone, address: [:street, :number, :complement, :neighborhood, :city, :state, :country, :zipcode])
    end
end
