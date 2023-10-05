class Contact < ApplicationRecord
  belongs_to :user

  before_save :format_cep
  before_save :format_phone
  before_save :format_cpf

  validates :name, presence: true
  validates :phone, presence: true
  validates :address, presence: true
  validates :cpf, presence: true
  
  validate :cpf_valid?
  validate :cpf_has_been_taken
  
  def format_cep
    self.address["zipcode"] = self.address["zipcode"].gsub(/\D/, '')
  end

  def format_phone
    self.phone = self.phone.gsub(/\D/, '')
  end

  def format_cpf
    self.cpf = self.cpf.gsub(/\D/, '')
  end

  def cpf_valid?
    return if cpf.blank?

    errors.add(:cpf, 'CPF inválido') unless CPF.valid?(cpf)
  end

  def cpf_has_been_taken
    return if cpf.blank?

    errors.add(:cpf, 'CPF já cadastrado') if Contact.where.not(id: id).where(cpf: cpf.gsub(/\D/, ''), user_id: user_id).exists?
  end
end
