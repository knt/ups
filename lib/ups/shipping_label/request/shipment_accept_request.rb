require 'ups/shipping_label/request/base'

module Ups
  module ShippingLabel
    module Request
      class ShipmentAcceptRequest < Base

        attr_accessor :customer_context, :shipment_digest

        REQUEST_ACTION  = "ShipAccept"

        def initialize(shipment_digest, options = {})
          @shipment_digest = shipment_digest

          @customer_context = options[:customer_context]
        end

        def to_xml
          request = Nokogiri::XML::Builder.new do |xml|
            xml.ShipmentAcceptRequest {
              xml.Request { 
                xml.RequestAction REQUEST_ACTION

                #Optional: TransactionRefence
                unless customer_context.nil?
                  xml.TransactionReference {
                    xml.CustomerContext customer_context
                  }
                end
              }

              xml.ShipmentDigest shipment_digest
            }
          end

          request.to_xml
        end
      end
    end
  end
end