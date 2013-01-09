require 'nokogiri'

module Ups
	module ShippingLabel
		module Response
			
			class Error

				attr_accessor :response, :error_severity, :error_code, :error_description, :minimum_retry_seconds,
					:error_location_element_name, :error_location_attribute_name, :error_digest
				def initialize(response)
					@response = response
					parse_response(response)
				end

				def parse_response(response)
					parsed_xml = Nokogiri::XML(response)

					@error_severity = parsed_xml.xpath('/Error/ErrorSeverity').children.first.to_s
					@error_code = parsed_xml.xpath('/Error/ErrorCode').children.first.to_s
					@error_description = parsed_xml.xpath('/Error/ErrorDescription').children.first.to_s
					@minimum_retry_seconds = parsed_xml.xpath('/Error/MinimumRetrySeconds').children.first.to_s
					@error_location_element_name = parsed_xml.xpath('/Error/ErrorLocation/ErrorLocationElementName').children.first.to_s
					@error_location_attribute_name = parsed_xml.xpath('/Error/ErrorLocation/ErrorLocationAttributeName').children.first.to_s
					@error_digest = parsed_xml.xpath('/Error/ErrorDigest').children.first.to_s
				end
			end
		end
	end
end