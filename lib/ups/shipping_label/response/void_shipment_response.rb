require 'ups/shipping_label/response/base'

module Ups
  module ShippingLabel
    module Response
      class VoidShipmentResponse < Base

        attr_accessor :response

        def initialize(response)
          @response = response
          parse_response(@response)
        end


        def parse_response(response)
          Nokogiri::XML(response)
      end
    end
  end
end    



#Optional: /VoidShipmentResponse/Respo nse/TransactionReference/CustomerContext
#/VoidShipmentResponse/Response/ResponseStatusCode
  #1 - Success
  #0 - Failure
#/VoidShipmentResponse/Response/ResponseStatusDescription
#Optional: /VoidShipmentResponse/Response/Error -only if error is present
#Optional: /VoidShipmentResponse/Response/Error/ErrorSeverity - only if error is present
#Optinal: /VoidShipmentResponse/Response/Error/ErrorCode - only if error is present
#Optinoal: /VoidShipmentResponse/Response/Error/ErrorDescription
#Optional: /VoidShipmentResponse/Response/Error/MinimumRetrySeconds
#Optional: /VoidShipmentResponse/Response/Error/ErrorLocation
#Optional: /VoidShipmentResponse/Respo nse/Error/ErrorLocation/ErrorLocationElementName
#Optinoal: /VoidShipmentResponse/Respo nse/Error/ErrorLocation/ErrorLocationAttributeName
#Optinoal: /VoidShipmentResponse/Respo nse/Error/ErrorDigest

#Optinal: /VoidShipmentResponse/Status - status information tags
  #Optional /VoidShipmentResponse/Status/ StatusType
  #Optional /VoidShipmentResponse/Status/ StatusType/Code 
    #1- success
    #0- failure
  #Optional /VoidShipmentResponse/Status/ StatusType/Description

#/VoidShipmentResponse/Status/ StatusCode

#/VoidShipmentResponse/Status/ StatusCode/Code
  #2 - Partially Voided
  #1 - Success
  #0 - Failure
#/VoidShipmentResponse/Status/ StatusCode/Description
#/VoidShipmentResponse/Packa geLevelResults
#/VoidShipmentResponse/Packa geLevelResults/TrackingNumbe r
#VoidShipmentResponse/Packa geLevelResults/StatusCode
#/VoidShipmentResponse/Packa geLevelResults/Description
      #   def succesful?
      #     true
      #     #ResponseStatusCode = 1 - succesful, 0 - not succesful
      #     #ResponseStatusDescription
      #     #Error
      #     #ErrorCode
      #     #ErrorSeverity
      #     #ErrorDescription

      #     #GraphicImage - /ShipmentAcceptResponse/ShipmentResults/ControlLogRecei pt/GraphicImage
      #     #TrackingNumber - /ShipmentAcceptResponse/ShipmentResults/PackageResults/ TrackingNumber


      #   end

      #   def label_image_base64
      #     @label_image
      #     #LabelImage - /ShipmentAcceptResponse/ShipmentResults/PackageResults/ LabelImage
      #     #/ShipmentAcceptResponse/ShipmentResults/PackageResults/ LabelImage/GraphicImage
      #   end

      #   def parse_response(response)
      #     @label_image = Nokogiri::XML(response).xpath("//ShipmentAcceptResponse/ShipmentResults/PackageResults/LabelImage/GraphicImage").children.first.to_s
      #   end
      # end