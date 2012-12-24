require 'spec_helper'

describe Ups::ShippingLabel::Request::AccessRequest do

	describe "#to_xml" do
		let(:access_license_number) { "123456" }
		let(:user_id) { "test_user" }
		let(:password) { "passw0rd" }
		let (:access_request) { Ups::ShippingLabel::Request::AccessRequest.new(access_license_number, user_id, password) }
		let (:xml) { Nokogiri.XML(access_request.to_xml) }

		it "builds xml with AccessLicenseNumber node set to access_license_number" do
			xml.at('/AccessRequest/AccessLicenseNumber').content.should == access_license_number
		end

		it "builds xml with UserId node set to user_id" do
			xml.at('/AccessRequest/UserId').content.should == user_id
		end

		it "builds xml with Password node set to password" do
			xml.at('/AccessRequest/Password').content.should == password
		end
	end
end