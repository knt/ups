module Ups
  
  class Address < RequestNode

    attr_accessor :address_line1, :city, :country_code, :address_line2, :address_line3, :state, :postal_code, :is_residential

    def initialize(options={})
      @required_attributes = [:address_line1, :city, :country_code]
      @optional_attributes = [:address_line2, :address_line3, :state, :postal_code, :is_residential]
      super(options)
    end

    def to_xml(root_node = 'Address')
      request = Nokogiri::XML::Builder.new do |xml|
        
        xml.send(root_node) {
          xml.AddressLine1 @address_line1
          xml.AddressLine2 @address_line2 unless @address_line2.nil?
          xml.AddressLine3 @address_line3 unless @address_line3.nil?
          xml.City @city
          xml.StateProvinceCode @state    unless @state.nil?
          xml.PostalCode @postal_code     unless @postal_code.nil?
          xml.CountryCode @country_code 
          xml.ResidentialAddress          unless @is_residential.nil?
        }
     
      end
      
      Nokogiri::XML(request.to_xml).root.to_xml
    end
  end
end
