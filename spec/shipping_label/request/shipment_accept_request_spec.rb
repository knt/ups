require 'spec_helper'

describe Ups::ShippingLabel::Request::ShipmentAcceptRequest do

	describe "#to_xml" do
		let (:shipment_digest) { "123jkjlaksf" }
		let (:shipment_accept_request) { Ups::ShippingLabel::Request::ShipmentAcceptRequest.new(shipment_digest) }
		let (:xml) { Nokogiri.XML(shipment_accept_request.to_xml) }

		it "builds xml with root node as ShipmentAcceptRequest" do
			xml.at('/ShipmentAcceptRequest').should_not be_nil
		end

		it "builds xml with /ShipmentAcceptRequest/Request node" do
			xml.at('/ShipmentAcceptRequest/Request').should_not be_nil
		end

		it "builds xml with /ShipmentAcceptRequest/Request/RequestAction set to ShipAccept" do
			xml.at('/ShipmentAcceptRequest/Request/RequestAction').content.should == "ShipAccept"
		end

		it "builds xml with /ShipmentAcceptRequest/ShipmentDigest set to shipment digest" do
			xml.at('/ShipmentAcceptRequest/ShipmentDigest').content.should == shipment_digest
		end

		context "if options[:customer_context] is nil" do
			it "does not include /ShipmentAcceptRequest/Request/TransactionReference" do
				xml.at('/ShipmentAcceptRequest/Request/TransactionReference').should be_nil
			end
		end

		context "if options[:customer_context] is present" do
			let(:customer_context) { "textCustomer123"}
			let (:shipment_accept_request) { Ups::ShippingLabel::Request::ShipmentAcceptRequest.new(shipment_digest, :customer_context => customer_context) }
			let (:xml) { Nokogiri.XML(shipment_accept_request.to_xml) }

			it "builds xml with /ShipmentAcceptRequest/Request/TransactionReference" do
				xml.at('/ShipmentAcceptRequest/Request/TransactionReference').should_not be_nil
			end

			it "builds xml with /ShipmentAcceptRequest/Request/TransactionReference/CustomerContext set to customer_context" do
				xml.at('/ShipmentAcceptRequest/Request/TransactionReference/CustomerContext').content.should == customer_context
			end
		end
	end
end