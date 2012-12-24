#require 'ups/shipping_label/request/base'
require 'nokogiri'

module Ups
  module ShippingLabel
    module Request
      class AccessRequest < Base

        def initialize(access_license_number, user_id, password)
          @access_license_number = access_license_number
          @user_id = user_id
          @password = password
        end

        def to_xml
          request = Nokogiri::XML::Builder.new do |xml|
            xml.AccessRequest {
              xml.AccessLicenseNumber @access_license_number
              xml.UserId @user_id
              xml.Password @password
            }
          end

          request.to_xml
        end
      end
    end
  end
end