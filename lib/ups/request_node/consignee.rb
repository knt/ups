module Ups
  class Consignee < Client
    
    def initialize(options = {})
      super
      @required_attributes << :address
      @optional_attributes << :location_id
      validate_required(options)
    end

    def to_xml
      request = Nokogiri::XML::Builder.new do |xml|
        
        xml.ShipTo {
          xml.CompanyName @name
          xml.AttentionName @attention_name          unless @attention_name.nil?
          xml.TaxIdentificationNumber @tax_id_number unless @tax_id_number.nil?
          xml.PhoneNumber @phone_number              unless @phone_number.nil?
          xml.FaxNumber @fax_number                  unless @fax_number.nil?
          xml.EMailAddress @email_address            unless @email_address.nil?
          xml.LocationID @location_id                unless @location_id.nil?
          xml << @address.to_xml
        }
      
      end

      Nokogiri::XML(request.to_xml).root.to_xml
    end
  end
end
