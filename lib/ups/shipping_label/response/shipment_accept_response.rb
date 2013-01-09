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
					true
					#ResponseStatusCode = 1 - succesful, 0 - not succesful
					#ResponseStatusDescription
					#Error
					#ErrorCode
					#ErrorSeverity
					#ErrorDescription

					#GraphicImage - /ShipmentAcceptResponse/ShipmentResults/ControlLogRecei pt/GraphicImage
					#TrackingNumber - /ShipmentAcceptResponse/ShipmentResults/PackageResults/ TrackingNumber


				end

				def label_image_base64
					@label_image
					#LabelImage - /ShipmentAcceptResponse/ShipmentResults/PackageResults/ LabelImage
					#/ShipmentAcceptResponse/ShipmentResults/PackageResults/ LabelImage/GraphicImage
				end

				def parse_response(response)
					@label_image = Nokogiri::XML(response).xpath("//ShipmentAcceptResponse/ShipmentResults/PackageResults/LabelImage/GraphicImage").children.first.to_s
				end
			end
		end
	end
end


