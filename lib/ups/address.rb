module Ups
  class Address

    attr_accessor :address_line1, :city, :country_code,
    :address_line2, :address_line3, :state_province, :postal_code, :is_residential

    def initialize(address_line1, city, country_code, options={})
      @address_line1 = address_line1
      @city = city
      @country_code = country_code

      @address_line2 = options[:address_line2]
      @address_line3 = options[:address_line3]
      @state_province = options[:state_province]
      @postal_code = options[:postal_code]

      @is_residential = options[:is_residential]
    end

    def to_xml
      request = Nokogiri::XML::Builder.new do |xml|
        xml.Address {
          xml.AddressLine1 @address_line1
          xml.AddressLine2 @address_line2 unless @address_line2.nil?
          xml.AddressLine3 @address_line3 unless @address_line3.nil?
          xml.City @city
          xml.StateProvinceCode @state_province unless @state_province.nil?
          xml.PostalCode @postal_code unless @postal_code.nil?
          xml.CountryCode @country_code
          xml.ResidentialAddress unless @is_residential.nil?
        }
      end
      
      Nokogiri::XML(request.to_xml).root.to_xml
    end
  end
end