module Ups
  class Shipper < Client

    def initialize(options = {})
      super

      @required_attributes << :shipper_number
      validate_required(options)
    end

    def to_xml
      request = Nokogiri::XML::Builder.new do |xml|
        
        xml.Shipper {
          xml.Name @name
          xml.AttentionName @attention_name          unless @attention_name.nil?
          xml.ShipperNumber @shipper_number          unless @shipper_number.nil?
          xml.TaxIdentificationNumber @tax_id_number unless @tax_id_number.nil?
          xml.PhoneNumber @phone_number              unless @phone_number.nil?
          xml.FaxNumber @fax_number                  unless @fax_number.nil?
          xml.EMailAddress @email_address            unless @email_address.nil?
          xml << @ship_from.to_xml('ShipFrom')       unless @ship_from.nil?
          xml << @address.to_xml                     unless @address.nil?
        }
      
      end

      Nokogiri::XML(request.to_xml).root.to_xml
    end
  end
end
