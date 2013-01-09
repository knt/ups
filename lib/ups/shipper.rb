require 'nokogiri'

module Ups
  class Shipper

    attr_accessor :name, :shipper_number, :address,

    #Optional
    :attention_name, :tax_identification_number, :phone_number, :fax_number, :email_address

    def initialize(name, shipper_number, address, options={})
      @name = name 
      @shipper_number = shipper_number
      @address = address #TODO: Validate that it is of type  Ups::Address

      @attention_name = options[:attention_name]
      @tax_identification_number = options[:tax_identification_number]
      @phone_number = options[:phone_number]
      @fax_number = options[:fax_number]
      @email_address = options[:email_address]
    end

    def to_xml
      request = Nokogiri::XML::Builder.new do |xml|
        xml.Shipper {
          xml.Name @name

          unless @attention_name.nil?
            xml.AttentionName @attention_name
          end

          xml.ShipperNumber @shipper_number

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
        }
      end

      Nokogiri::XML(request.to_xml).root.to_xml
    end
  end
end