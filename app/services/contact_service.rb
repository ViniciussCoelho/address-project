class ContactService
  def initialize
    @viacep = ViaCep::Address
    @geocoder = Geokit::Geocoders::GoogleGeocoder
    @geocoder.api_key = "AIzaSyDx8Iwc6lupBGsj325xV_E5fHAojFfhjMc"
  end

  def get_contacts(user_id:, page: 1, per_page: 10, order_by: 'name', order: 'desc', search: '')
    contacts = Contact.where(user_id: user_id).order("LOWER(#{order_by}) #{order}")

    if search.present?
      contacts = contacts.where('name ILIKE ? or cpf ILIKE ?', "%#{search}%", "%#{search.gsub(/[-.*]/, '')}%")
    end

    contacts.paginate(page: page, per_page: per_page)
  end

  def get_address_by_zipcode(zipcode:)
    address = @viacep.new(zipcode)

    return { status: 404, message: 'CEP não encontrado' } if address.nil?

    { status: 200, address: address}
  end


  def geocode_address(address)
    location = @geocoder.geocode(address)
    
    if location.success
      latitude = location.lat.to_s
      longitude = location.lng.to_s
      { success: true, latitude: latitude, longitude: longitude }
    else
      { success: false }
    end
  end
end