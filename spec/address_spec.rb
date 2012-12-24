require 'spec_helper'

describe Ups::Address do

	let(:address_line1) { "123 Test Street" }
	let(:city) { "Boston"}
	let (:country_code) { "US"}
	let(:address) { build_address(address_line1, city, country_code) }

	specify { address.address_line1.should == address_line1 }
	specify { address.city.should == city }

	context "if options[:address_line2] is present" do
		let(:address_line2) { "Suite 200"}
		let(:options) { {:address_line2 => address_line2} }
		let(:address) { build_address(address_line1, city, country_code, options) }

		it "sets address_line2" do
			address.address_line2.should == address_line2
		end
	end

	context "if options[:address_line3] is present" do
		let(:address_line3) { "Dept of Stuff"}
		let(:options) { {:address_line3 => address_line3} }
		let(:address) { build_address(address_line1, city, country_code, options) }

		it "sets address_line3" do
			address.address_line3.should == address_line3
		end
	end

	context "if options[:state_province] is present" do
		let(:state_province) { "MA"}
		let(:options) { {:state_province => state_province} }
		let(:address) { build_address(address_line1, city, country_code, options)}

		it "sets state_province" do
			address.state_province.should == state_province
		end
	end

	context "if options[:postal_code] is present" do
		let(:postal_code) { "02139"}
		let(:options) { {:postal_code => postal_code} }
		let(:address) { build_address(address_line1, city, country_code, options) }

		it "sets postal_code" do
			address.postal_code.should == postal_code
		end
	end

	def build_address(address_line1, city, country_code, options={})
		Ups::Address.new(address_line1, city, country_code, options)
	end
end