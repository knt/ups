require 'nokogiri'

module Ups
  module ShippingLabel
    module Request
      class Base

        XPCI_VERSION = "1.0001"

        def node_for_transaction_reference(customer_context)
          node = Nokogiri::XML::Builder.new do |xml|
            xml.TransactionReference {
              xml.CustomerContext customer_context
              xml.XpciVersion XPCI_VERSION
            }
          end

          Nokogiri::XML(node.to_xml).root.to_xml
        end
      end
    end
  end
end