require 'nokogiri'

module Ups
  module ShippingLabel
    module Request
      class Base

        XPCI_VERSION = "1.0001"

        def node_for_transaction_reference(customer_context)
          XmlNode.new("TransactionReference") do |transaction_reference_node|
            transaction_reference_node << XmlNode.new("CustomerContext", customer_context)
            transaction_reference_node << XmlNode.new("XpciVersion", XPCI_VERSION)
          end
        end
      end
    end
  end
end