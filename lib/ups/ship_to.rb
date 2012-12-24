#TODO: Combine with Shipper

module Ups
	class ShipTo

		attr_accessor :company_name, :address,

		#Optional
		:attention_name, :tax_identification_number, :phone_number, :fax_number, :email_address
		
		def initialize(company_name, address, options={})
			@company_name = company_name
			@address = address

			@attention_name = options[:attention_name]
			@tax_identification_number = options[:tax_identification_number]
			@phone_number = options[:phone_number]
			@fax_number = options[:fax_number]
			@email_address = options[:email_address]
		end
	end
end