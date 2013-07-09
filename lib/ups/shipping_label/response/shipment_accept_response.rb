require 'ups/shipping_label/response/base'

module Ups
  module ShippingLabel
    module Response
      class ShipmentAcceptResponse < Base

				def initialize(response)
					@response = response
					parse_response(response)
				end

				def succesful?
					@response_status_code == SUCCESS_CODE
				end


					#ResponseStatusCode = 1 - succesful, 0 - not succesful
					#ResponseStatusDescription
					#Error
					#ErrorCode
					#ErrorSeverity
					#ErrorDescription

					#GraphicImage - /ShipmentAcceptResponse/ShipmentResults/ControlLogRecei pt/GraphicImage
					#TrackingNumber - /ShipmentAcceptResponse/ShipmentResults/PackageResults/ TrackingNumber

				def label_image_base64
					@label_image
					#LabelImage - /ShipmentAcceptResponse/ShipmentResults/PackageResults/ LabelImage
					#/ShipmentAcceptResponse/ShipmentResults/PackageResults/ LabelImage/GraphicImage
				end

				def parse_response(response)
					parsed_xml = Nokogiri::XML(response)

					#TODO: This might not be present
					customer_context_node = parsed_xml.xpath('/ShipmentAcceptResponse/Response/TransactionReference/CustomerContext')
					if !customer_context_node.nil?
						@customer_context = customer_context_node.children.first.to_s
					end

					#TODO: Make a response status code class
					@response_status_code = parsed_xml.xpath('/ShipmentAcceptResponse/Response/ResponseStatusCode').children.first.to_s
					@response_status_description = parsed_xml.xpath('/ShipmentAcceptResponse/Response/ResponseStatusDescription').children.first.to_s

					@error = Ups::ShippingLabel::Response::Error.new(parsed_xml.xpath('/ShipmentConfirmResponse/Response/Error').children.first.to_s)

					shipment_results_node = Nokogiri::XML(response).xpath('/ShipmentAcceptResponse/ShipmentResults')

					shipment_charges_node = parsed_xml.xpath('/ShipmentAcceptResponse/ShipmentResults/ShipmentCharges')
					if !shipment_charges_node.nil?
						@rate_chart = shipment_charges_node.xpath('/RateChart').content

						transportation_charges_node = shipment_charges_node.xpath('/TransportationCharges').content
						@transportation_charges = Ups::ShipmentCharges.from_xml(transportation_charges_node)

						service_options_charges_node = shipment_charges_node.xpath('/ServiceOptionsCharges').content
						@service_options_charges = Ups::ShipmentCharges.from_xml(service_options_charges_node)

						total_charges_node = shipment_charges_node.xpath('/TotalCharges').content
						@total_shipment_charges = Ups::ShipmentCharges.from_xml(total_charges_node)
					end

					negotiated_rates_node = parsed_xml.xpath('/ShipmentAcceptResponse/NegotiatedRates')
					if !negotiated_rates_node.nil?
						net_summary_charges_node = negotiated_rates_node.xpath('/NetSummaryCharges')
						if !net_summary_charges_node.nil?
							grand_total_node = net_summary_charges_node.xpath('/GrandTotal')
							@negotiated_rates_net_summary_charges = Ups::ShipmentCharges.new(grand_total_node)
						end
					end

					billing_weight_node = parsed_xml.xpath('/ShipmentAcceptResponse/BillingWeight')
					@billing_weight_unit_of_measurement_code = billing_weight_node.xpath('/UnitOfMeasurement/Code')
					@billing_weight_unit_of_measurement_description = billing_weight_node.xpath('/UnitOfMeasurement/Description')
					@billing_weight = billing_weight_node.xpath('/Weight')

					@shipment_identification_number = parsed_xml.xpath('/ShipmentAcceptResponse/ShipmentIdentificationNumber')

					#@label_image = Nokogiri::XML(response).xpath("//ShipmentAcceptResponse/ShipmentResults/PackageResults/LabelImage/GraphicImage").children.first.to_s
				end
			end
		end
	end
end

# /ShipmentAcceptResponse/ShipmentResults/ControlLogReceipt #may not be present
# /ShipmentAcceptResponse/ShipmentResults/ControlLogReceipt/ImageFormat #required if parent exists
# /ShipmentAcceptResponse/ShipmentResults/ControlLogReceipt/ImageFormat/Code
# /ShipmentAcceptResponse/ShipmentResults/ControlLogReceipt/ImageFormat/Description
# /ShipmentAcceptResponse/ShipmentResults/ControlLogReceipt/GraphicImage

# /ShipmentAcceptResponse/ShipmentResults/PackageResults #not required but many
# /ShipmentAcceptResponse/ShipmentResults/PackageResults/TrackingNumber
# /ShipmentAcceptResponse/ShipmentResults/PackageResults/ServiceOptionsCharges #may or may not exist
# /ShipmentAcceptResponse/ShipmentResults/PackageResults/ServiceOptionsCharges/CurrencyCode #will exist if above exists
# /ShipmentAcceptResponse/ShipmentResults/PackageResults/ServiceOptionsCharges/MonetaryValue #will exist if above exists

# /ShipmentAcceptResponse/ShipmentResults/PackageResults/LabelImage 	#may not be present
# /ShipmentAcceptResponse/ShipmentResults/PackageResults/LabelImage/LabelImageFormat
# /ShipmentAcceptResponse/ShipmentResults/PackageResults/LabelImage/LabelImageFormat/Code
# /ShipmentAcceptResponse/ShipmentResults/PackageResults/LabelImage/LabelImageFormat/Description
# /ShipmentAcceptResponse/ShipmentResults/PackageResults/LabelImage/GraphicImage
# /ShipmentAcceptResponse/ShipmentResults/PackageResults/ LabelImage/InternationalSignatureGraphicImage #may not be present
# /ShipmentAcceptResponse/ShipmentResults/PackageResults/ LabelImage/HTMLImage	#only returned for gif and png image formats
# /ShipmentAcceptResponse/ShipmentResults/PackageResults/ LabelImage/PDF417 #return service only

# /ShipmentAcceptResponse/ShipmentResults/PackageResults/ Receipt  #not for ERL or PRL shipments
# /ShipmentAcceptResponse/ShipmentResults/PackageResults/ Receipt/Image 	#receipt of return shipments
# /ShipmentAcceptResponse/ShipmentResults/PackageResults/ Receipt/Image/ImageFormat
# /ShipmentAcceptResponse/ShipmentResults/PackageResults/ Receipt/Image/ImageFormat/Code
# /ShipmentAcceptResponse/ShipmentResults/PackageResults/ Receipt/Image/ImageFormat/Description
# /ShipmentAcceptResponse/ShipmentResults/PackageResults/ Receipt/Image/GraphicImage

# /ShipmentAcceptResponse/ShipmentResults/PackageResults/ USPSPICNumber	#may not exist

# /ShipmentAcceptResponse/ShipmentResults/Form #international only, may not exist
# /ShipmentAcceptResponse/ShipmentResults/Form/Code
# /ShipmentAcceptResponse/ShipmentResults/Form/Description
# /ShipmentAcceptResponse/ShipmentResults/Form/Image
# /ShipmentAcceptResponse/ShipmentResults/Form/Image/ImageFormat
# /ShipmentAcceptResponse/ShipmentResults/Form/Image/ImageFormat/Code
# /ShipmentAcceptResponse/ShipmentResults/Form/Image/ImageFormat/Description
# /ShipmentAcceptResponse/ShipmentResults/Form/Image/GraphicImage
# /ShipmentAcceptResponse/ShipmentResults/Form/FormGroupId
# /ShipmentAcceptResponse/ShipmentResults/Form/FormGroupIdName

# /ShipmentAcceptResponse/ShipmentResults/CODTurnInPage
# /ShipmentAcceptResponse/ShipmentResults/CODTurnInPage /Image
# /ShipmentAcceptResponse/ShipmentResults/CODTurnInPage /Image/ImageFormat
# /ShipmentAcceptResponse/ShipmentResults/CODTurnInPage /Image/ImageFormat/Code
# /ShipmentAcceptResponse/ShipmentResults/CODTurnInPage /Image/ImageFormat/Description
# /ShipmentAcceptResponse/ShipmentResults/CODTurnInPage /Image/GraphicImage

# /ShipmentAcceptResponse/ShipmentResults/HighValueReport
# /ShipmentAcceptResponse/ShipmentResults/HighValueReport /Image
# /ShipmentAcceptResponse/ShipmentResults/HighValueReport /Image/ImageFormat
# /ShipmentAcceptResponse/ShipmentResults/HighValueReport /Image/ImageFormat/Code
# /ShipmentAcceptResponse/ShipmentResults/HighValueReport /Image/ImageFormat/Description
# /ShipmentAcceptResponse/ShipmentResults/HighValueReport /Image/GraphicImage

# /ShipmentAcceptResponse/ShipmentResults/LabelURL
# /ShipmentAcceptResponse/ShipmentResults/LocalLanguageLabelURL
# /ShipmentAcceptResponse/ShipmentResults/ReceiptURL
# /ShipmentAcceptResponse/ShipmentResults/LocalLanguageReceiptURL





