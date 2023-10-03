class ContactService
  def initialize
    @geocoder = Geokit::Geocoders::GoogleGeocoder
    @geocoder.api_key = ENV['GOOGLE_API_KEY']
  end

  def get_contacts(user_id:, page: 1, per_page: 10, order_by: 'name', order: 'desc', search: '')
    contacts = Contact.where(user_id: user_id).order("#{order_by} #{order}")

    if search.present?
      contacts = contacts.where('name ILIKE ?', "%#{search}%")
    end

    contacts.paginate(page: page, per_page: per_page)
  end
end