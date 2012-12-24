module Ups
	class Shipper

		attr_accessor :name, :shipper_number, :address,

		#Optional
		:attention_name, :tax_identification_number, :phone_number, :fax_number, :email_address

		def initialize(name, shipper_number, address, options={})
			@name = name 
			@shipper_number = shipper_number
			@address = address #TODO: Validate that it is of type  Ups::Address

			@attention_name = options[:attention_name]
			@tax_identification_number = options[:tax_identification_number]
			@phone_number = options[:phone_number]
			@fax_number = options[:fax_number]
			@email_address = options[:email_address]
		end
	end
end