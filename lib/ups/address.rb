module Ups
	class Address

		attr_accessor :address_line1, :city, :country_code,

		#Optional 
		:address_line2, :address_line3, :state_province, :postal_code

		def initialize(address_line1, city, country_code, options={})
			@address_line1 = address_line1
			@city = city
			@country_code = country_code

			@address_line2 = options[:address_line2]
			@address_line3 = options[:address_line3]
			@state_province = options[:state_province]
			@postal_code = options[:postal_code]
		end
	end
end