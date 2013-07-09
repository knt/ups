require 'net/https'
require 'ups/shipping_label/request/access_request'
require 'ups/shipping_label/request/shipment_confirm_request'
require 'ups/shipping_label/response/shipment_confirm_response'
require 'ups/shipping_label/request/shipment_accept_request'
require 'ups/shipping_label/response/shipment_accept_response'


module ShippingLabel
  class ShippingLabelGenerator

    TEST_SHIPMENT_CONFIRM_URL = "https://wwwcie.ups.com/ups.app/xml/ShipConfirm"
    TEST_SHIPMENT_ACCEPT_URL = "https://wwwcie.ups.com/ups.app/xml/ShipAccept"

    def initialize(access_license_number, user_id, password)
      @access_request = Ups::ShippingLabel::Request::AccessRequest.new(access_license_number, user_id, password)


    end

    def generate_shipping_label(shipper, ship_to, service_code, packages)
      #1. Make ShipmentConfirmRequest
      shipper_address = Ups::Address.new("12803 Correen Hills Drive", "Bristow", "US", :postal_code => "20136", :state_province => "VA")
      shipper = Ups::Shipper.new("Grumpy Cat", "29A20E", shipper_address)

      ship_to_address = Ups::Address.new("5047 Wellington Rd", "Gainesville", "US", :postal_code => "20155", :state_province => "VA")
      ship_to = Ups::ShipTo.new("Mr Grumpystilskins", ship_to_address)
      
      packages = [Ups::Package.new("2", "4", "6", "8", :packaging_type_code => "02")]
      shipment_confirm_request = Ups::ShippingLabel::Request::ShipmentConfirmRequest.new(shipper, ship_to, "03", packages)

      # #2. Send ShipmentConfirmRequest and get ShipmentConfirmResponse
      response = send_request(shipment_confirm_request, TEST_SHIPMENT_CONFIRM_URL)

      #4. Parse ShipmentConfirmResponse
      shipment_confirm_response = Ups::ShippingLabel::Response::ShipmentConfirmResponse.new(response)

      #5. If ShipmentConfirmResponse is succesful
      if shipment_confirm_response.succesful?
        #6. Build ShipmentAcceptRequest
        shipment_accept_request = Ups::ShippingLabel::Request::ShipmentAcceptRequest.new(shipment_confirm_response.digest)

        #7. Send ShipmentAcceptRequest and get ShipmentAcceptResponese
        response = send_request(shipment_accept_request, TEST_SHIPMENT_ACCEPT_URL)

        #8. Parse ShipmentAcceptResponese
        shipment_accept_response = Ups::ShippingLabel::Response::ShipmentAcceptResponse.enew(response)

      #  #9. If ShipmentConfirmResponse is succesful, get image
      #   if shipment_accept_response.succesful?
      #     File.open("shipping_label.gif", 'wb') do|f|
      #       f.write(Base64.decode64(shipment_accept_response.label_image_base64))
      #     end
      #   end
      end
    end

    def send_request(request, url)
      request = @access_request.to_xml.to_s + request.to_xml.to_s
      plain_post(url, request)
    end

    def plain_post(url, data, headers = {})
      uri   = URI.parse(url)      
      http = Net::HTTP.new(uri.host, 443)
      http.use_ssl = true
      http.post(uri.request_uri, data, headers).body   
    end
  end
end


# Void Request
# High Value Report
# Label Recovery
# A proportional UPS Address label



#-ShipmentConfirmRequest (shipment info) --> ShipConfirm /  ShipmentConfirmResponse
#-ShipmentAcceptRequest / ShipmentAcceptResponse