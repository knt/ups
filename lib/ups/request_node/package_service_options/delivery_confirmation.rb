module Ups
  
  class DeliveryConfirmation < RequestNode
    DCIS_TYPES = {
      '1'  => 'Delivery Confirmation',
      '2'  => 'Delivery Confirmation Signature Required',
      '3'  => 'Delivery Confirmation Adult Signature Required',
      '4'  => 'USPS Delivery Confirmation'
    }


    attr_accessor :dcis_type, :dcis_number

    
    def initialize(options = {})
      super(options)
      @required_attributes = [:dcis_type]
      @optional_attributes = [:dcis_number]
    end

    def to_xml
      
      request = Nokogiri::XML::Builder.new do |xml|

        xml.DeliveryConfirmation{
          xml.DCISType @dcis_type
          xml.DCISNumber @dcis_number if @dcis_number
        }
      
      end
      
      Nokogiri::XML(request.to_xml).root.to_xml
    end


  end
end
