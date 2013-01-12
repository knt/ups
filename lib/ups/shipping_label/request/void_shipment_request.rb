require 'ups/shipping_label/request/base'

module Ups
  module ShippingLabel
    module Request
      class VoidShipmentRequest < Base

        attr_accessor :shipment_identification_number, :tracking_numbers, :customer_context

        REQUEST_ACTION = "1"

        def initialize(shipment_identification_number, options={})
          @shipment_identification_number = shipment_identification_number
          
          @tracking_numbers = options[:tracking_numbers]
          @customer_context = options[:customer_context]
        end

        def to_xml
          request = Nokogiri::XML::Builder.new do |xml|
            xml.VoidShipmentRequest {
              xml.Request {
                xml.RequestAction REQUEST_ACTION
                xml.TransactionReference {
                  xml.CustomerContext customer_context
                }
              }

              if !tracking_numbers.nil? && tracking_numbers.any?
                xml.ExpandedVoidShipment {
                  xml.ShipmentIdentificationNumber shipment_identification_number

                  tracking_numbers.each do |tracking_number|
                    xml.TrackingNumber tracking_number
                  end
                }
              else
                xml.ShipmentIdentificationNumber shipment_identification_number
              end
            }
          end

          request.to_xml
        end
      end
    end
  end
end