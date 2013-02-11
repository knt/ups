
module Ups
	class ShipmentCharge

		attr_accessor :currency_code, :monetary_value

		def initialize(currency_code, monetary_value)
			@currency_code = currency_code
			@monetary_value = monetary_value
		end

		def self.from_xml(xml)
			currency_code_node = xml.xpath('//CurrencyCode')
			currency_code = currency_code_node.nil? ? nil : currency_code_node.content
			
			monetary_value_node = xml.xpath('//MonetaryValue')
			monetary_value = monetary_value_node.nil? ? nil : monetary_value_node.content

			if currency_code.nil? || monetary_value.nil?
				raise ArgumentError, 'Could not parse Currency Code or Monetary Value from xml'
			else
				Ups::ShipmentCharge.new(currency_code, monetary_value)
			end
		end
	end
end