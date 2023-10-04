require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:user) { User.create(name: 'Test User', email: 'test@example.com', password: 'password') }
  let(:contact) { Contact.new(user: user, name: 'Test Contact', phone: '1234567890', cpf: '88734343040', address: { "zipcode": "81470266"}) }

  describe 'validations' do
    it { should validate_presence_of(:cpf) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:phone) }
    it { should validate_presence_of(:address) }
  end
  
  describe 'formatting' do
    it 'formats cpf by removing non-numeric characters' do
      contact.cpf = '503.857.100-03'
      contact.save!
      expect(contact.cpf).to eq('50385710003')
    end
  
    it 'formats phone by removing non-numeric characters' do
      contact.phone = '(12) 34567-8901'
      contact.save!
      expect(contact.phone).to eq('12345678901')
    end
  
    it 'formats cep by removing non-numeric characters' do
      contact.address['zipcode'] = '12345-678'
      contact.save!
      expect(contact.address['zipcode']).to eq('12345678')
    end
  end
  
  describe 'CPF validation' do
    it 'adds an error if the CPF is invalid' do
      contact.cpf = '12345678909'
      contact.save
      expect(contact.errors[:cpf]).to include('CPF inválido')
    end

    it 'needs to be unique for each user' do
        contact.save
        new_contact = Contact.new(user: user, name: 'Test Contact', phone: '1234567890', cpf: '88734343040', address: { "zipcode": "81470266"})
        new_contact.save
        expect(new_contact.errors[:cpf]).to include('has already been taken')
    end
  end
end