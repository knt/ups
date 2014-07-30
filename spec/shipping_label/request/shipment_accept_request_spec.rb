require 'spec_helper'

describe Ups::ShippingLabel::Request::ShipmentAcceptRequest do

	describe "#to_xml" do
		let (:shipment_digest) { "123jkjlaksf" }
		let (:shipment_accept_request) { Ups::ShippingLabel::Request::ShipmentAcceptRequest.new(shipment_digest) }
		let (:xml) { Nokogiri.XML(shipment_accept_request.to_xml) }

		it "builds xml with root node as ShipmentAcceptRequest" do
			expect(xml.at('/ShipmentAcceptRequest')).not_to be_nil
		end

		it "builds xml with /ShipmentAcceptRequest/Request node" do
			expect(xml.at('/ShipmentAcceptRequest/Request')).not_to be_nil
		end

		it "builds xml with /ShipmentAcceptRequest/Request/RequestAction set to ShipAccept" do
			expect(xml.at('/ShipmentAcceptRequest/Request/RequestAction').content).to eq("ShipAccept")
		end

		it "builds xml with /ShipmentAcceptRequest/ShipmentDigest set to shipment digest" do
			expect(xml.at('/ShipmentAcceptRequest/ShipmentDigest').content).to eq(shipment_digest)
		end

		context "if options[:customer_context] is nil" do
			it "does not include /ShipmentAcceptRequest/Request/TransactionReference" do
				expect(xml.at('/ShipmentAcceptRequest/Request/TransactionReference')).to be_nil
			end
		end

		context "if options[:customer_context] is present" do
			let(:customer_context) { "textCustomer123"}
			let (:shipment_accept_request) { Ups::ShippingLabel::Request::ShipmentAcceptRequest.new(shipment_digest, :customer_context => customer_context) }
			let (:xml) { Nokogiri.XML(shipment_accept_request.to_xml) }

			it "builds xml with /ShipmentAcceptRequest/Request/TransactionReference" do
				expect(xml.at('/ShipmentAcceptRequest/Request/TransactionReference')).not_to be_nil
			end

			it "builds xml with /ShipmentAcceptRequest/Request/TransactionReference/CustomerContext set to customer_context" do
				expect(xml.at('/ShipmentAcceptRequest/Request/TransactionReference/CustomerContext').content).to eq(customer_context)
			end
		end
	end
end