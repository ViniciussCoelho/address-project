require 'rails_helper'

RSpec.describe ContactService do
  let(:contact_service) { ContactService.new }

  describe '#get_contacts' do
    let(:user_id) { 1 }
    let(:contacts) { [double('Contact', name: 'John Doe', cpf: '111.111.111-11', user_id: user_id)] }

    before do
      allow(Contact).to receive_message_chain(:where, :order, :paginate).and_return(contacts)
    end

    it 'returns contacts for a user' do
      expect(contact_service.get_contacts(user_id: user_id)).to eq(contacts)
    end
  end

  describe '#get_address_by_zipcode' do
    let(:zipcode) { '12345-000' }
    let(:address) {{ street: 'Test Street', number: '123', complement: 'Test Complement', neighborhood: 'Test Neighborhood', city: 'Test City', state: 'Test State', country: 'Test Country', zipcode: '12345678' }}

    before do
      allow(ViaCep::Address).to receive(:new).and_return(address)
    end

    it 'returns address details' do
      expect(contact_service.get_address_by_zipcode(zipcode: zipcode)).to eq({ status: 200, address: address })
    end

    context 'when address is not found' do
      before do
        allow(address).to receive(:nil?).and_return(true)
      end

      it 'returns not found error' do
        expect(contact_service.get_address_by_zipcode(zipcode: zipcode)).to eq({ status: 404, message: 'CEP não encontrado' })
      end
    end
  end

  describe '#geocode_address' do
    let(:address) {{ street: 'Test Street', number: '123', complement: 'Test Complement', neighborhood: 'Test Neighborhood', city: 'Test City', state: 'Test State', country: 'Test Country', zipcode: '12345678' }}

    it 'returns geocoding result' do
        contact_service.geocode_address(address.to_s)
    end
  end
end
