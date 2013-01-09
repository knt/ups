require 'ups/shipping_label/response/base'
require 'ups/shipping_label/response/error'

module Ups
  module ShippingLabel
    module Response
      class ShipmentConfirmResponse < Base

				attr_accessor :digest,

				:customer_context, :response_status_code, :response_status_description, :error

				def initialize(response)
					@response = response
					parse_response(response)
				end

				def succesful?
					if @response_status_code == "1"
						return true
					else
						return false
					end
				end

				def parse_response(response)
					parsed_xml = Nokogiri::XML(response)

					@customer_context = parsed_xml.xpath('/ShipmentConfirmResponse/Response/TransactionReference/CustomerContext').children.first.to_s
					#TODO: Make a response status code class
					@response_status_code = parsed_xml.xpath('/ShipmentConfirmResponse/Response/ResponseStatusCode').children.first.to_s
					@response_status_description = parsed_xml.xpath('/ShipmentConfirmResponse/Response/ResponseStatusDescription').children.first.to_s

					@error = Ups::ShippingLabel::Response::Error.new(parsed_xml.xpath('/ShipmentConfirmResponse/Response/Error').children.first.to_s)
					@digest = Nokogiri::XML(@response).xpath("//ShipmentConfirmResponse/ShipmentDigest").children.first.to_s

					#TODO: /ShipmentConfirmResponse/ShipmentCharges
					#TODO: /ShipmentConfirmResponse/ShipmentCharges/RateChart

					#TODO: /ShipmentConfirmResponse/ShipmentCharges/TransportationCharges
					#TODO: /ShipmentConfirmResponse/ShipmentCharges/TransportationCharges/CurrencyCode
					#TODO: /ShipmentConfirmResponse/ShipmentCharges/TransportationCharges/MonetaryValue	
					
					#TODO: /ShipmentConfirmResponse/ShipmentCharges/ServiceOptionsCharges
					#TODO: /ShipmentConfirmResponse/ShipmentCharges/ServiceOptionsCharges/CurrencyCode
					#TODO: /ShipmentConfirmResponse/ShipmentCharges/ServiceOptionsCharges/MonetaryValue
					
					#TODO: /ShipmentConfirmResponse/ShipmentCharges/TotalCharges
					#TODO: /ShipmentConfirmResponse/ShipmentCharges/TotalCharges/CurrencyCode
					#TODO: /ShipmentConfirmResponse/ShipmentCharges/TotalCharges/MonetaryValue
					
					#TODO: /ShipmentConfirmResponse/BillingWeight
					#TODO: /ShipmentConfirmResponse/BillingWeight/UnitOfMeasurement
					#TODO: /ShipmentConfirmResponse/BillingWeight/UnitOfMeasurement/Code
					#TODO: /ShipmentConfirmResponse/BillingWeight/UnitOfMeasurement/Description
					#TODO: /ShipmentConfirmResponse/BillingWeight/Weight
					
					#TODO: /ShipmentConfirmResponse/ShipmentIdentificationNumber
					#TODO: /ShipmentConfirmResponse/ShipmentDigest
					
					#TODO: /ShipmentConfirmResponse/NegotiatedRates
					#TODO: /ShipmentConfirmResponse/NegotiatedRates/NetSummaryCharges
					#TODO: /ShipmentConfirmResponse/NegotiatedRates/NetSummaryCharges/GrandTotal
					#TODO: /ShipmentConfirmResponse/NegotiatedRates/NetSummaryCharges/GrandTotal/CurrencyCode
					#TODO: /ShipmentConfirmResponse/NegotiatedRates/NetSummaryCharges/GrandTotal/MonetaryValue
				end
			end
		end
	end
end




