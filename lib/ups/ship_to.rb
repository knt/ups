#TODO: Combine with Shipper

module Ups
  class ShipTo

    attr_accessor :company_name, :address,

    #Optional
    :attention_name, :tax_identification_number, :phone_number, :fax_number, :email_address, :location_id
    
    def initialize(company_name, address, options={})
      @company_name = company_name
      @address = address

      @attention_name = options[:attention_name]
      @tax_identification_number = options[:tax_identification_number]
      @phone_number = options[:phone_number]
      @fax_number = options[:fax_number]
      @email_address = options[:email_address]
      @location_id = options[:location_id]
    end

    def to_xml
      request = Nokogiri::XML::Builder.new do |xml|
        #TODO: Should be ShipFrom if ShipFrom address
        xml.ShipTo {
          xml.CompanyName @company_name

          unless @attention_name.nil?
            xml.AttentionName @attention_name
          end

          unless @tax_identification_number.nil?
            xml.TaxIdentificationNumber @tax_identification_number
          end

          unless @phone_number.nil?
            xml.PhoneNumber @phone_number
          end

          unless @fax_number.nil?
            xml.FaxNumber @fax_number
          end

          unless @email_address.nil?
            xml.EMailAddress @email_address
          end

          xml << @address.to_xml

          unless @location_id.nil?
            xml.LocationID @location_id
          end
        }
      end

      Nokogiri::XML(request.to_xml).root.to_xml
    end
  end
end