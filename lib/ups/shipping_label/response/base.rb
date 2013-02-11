require 'nokogiri'

module Ups
	module ShippingLabel
		module Response
			class Base
				attr_accessor :response_status_code

				SUCCESS_CODE = "1"

				def initialize(response)
					@response = response
					parse_response(response)
				end

				def succesful?
					@response_status_code == SUCCESS_CODE
				end
			end
		end
	end
end
