require 'spec_helper'

describe Ups::ShippingLabel::Request::AccessRequest do

	describe "#to_xml" do
		let(:access_license_number) { "123456" }
		let(:user_id) { "test_user" }
		let(:password) { "passw0rd" }
		let (:access_request) { Ups::ShippingLabel::Request::AccessRequest.new(access_license_number, user_id, password) }
		let (:xml) { Nokogiri.XML(access_request.to_xml) }

		it "builds xml with AccessLicenseNumber node set to access_license_number" do
			expect(xml.at('/AccessRequest/AccessLicenseNumber').content).to eq(access_license_number)
		end

		it "builds xml with UserId node set to user_id" do
			expect(xml.at('/AccessRequest/UserId').content).to eq(user_id)
		end

		it "builds xml with Password node set to password" do
			expect(xml.at('/AccessRequest/Password').content).to eq(password)
		end
	end
end