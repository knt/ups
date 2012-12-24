require 'ups/shipping_label/request/base'

module Ups
  module ShippingLabel
    module Request
      class VoidShipmentRequest < Base

        attr_accessor :shipment_identification_number, :tracking_number, :customer_context

        REQUEST_ACTION = "1"

        def initialize(shipment_identification_number, options={})
          @shipment_identification_number = shipment_identification_number
          
          #@tracking_number = options[:tracking_number]
          @customer_context = options[:customer_context]
        end

        def to_xml
          request = Nokogiri::XML::Builder.new do |xml|
            xml.VoidShipmentRequest {
              xml.Request {
                xml.RequestAction REQUEST_ACTION
                xml.TransactionReference {
                  unless customer_context.nil?
                    xml.CustomerContext customer_context
                  end
                }
              }

              xml.ShipmentIdentificationNumber shipment_identification_number

              #TODO: If ShipmentIdentificationNumber is not provided, ExpandedVoidShipment is expected
              #TODO: /VoidShipmentRequest/ExpandedVoidShipment
              #TODO: /VoidShipmentRequest/ExpandedVoidShipment/ShipmentIdentificationNumber
              #TODO: /VoidShipmentRequest/ExpandedVoidShipment/TrackingNumber

              #TODO: Is more than one tracking number allowed?
            }
          end

          request.to_xml
        end
      end
    end
  end
end