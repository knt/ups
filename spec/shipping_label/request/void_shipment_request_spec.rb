require 'spec_helper'

describe Ups::ShippingLabel::Request::VoidShipmentRequest do

	describe "#to_xml" do
		let(:shipment_identification_number) { "123314234"}
		let (:void_shipment_request) { Ups::ShippingLabel::Request::VoidShipmentRequest.new(shipment_identification_number) }
		let (:xml) { Nokogiri.XML(void_shipment_request.to_xml) }

		it "builds xml with root node as VoidShipmentRequest" do
			xml.at('/VoidShipmentRequest').should_not be_nil
		end

		it "builds xml with /VoidShipmentRequest/Request node" do
			xml.at('/VoidShipmentRequest/Request').should_not be_nil
		end

		it "builds xml with /VoidShipmentRequest/Request/RequestAction set to 1" do
			xml.at('/VoidShipmentRequest/Request/RequestAction').content.should == "1"
		end

		it "builds xml with /VoidShipmentRequest/Request/TransactionReference" do
			xml.at('/VoidShipmentRequest/Request/TransactionReference').should_not be_nil
		end

		context "if options[:customer_context] is present" do
			let(:customer_context) { "textCustomer123"}
			let (:void_shipment_request) { Ups::ShippingLabel::Request::VoidShipmentRequest.new(shipment_identification_number, :customer_context => customer_context) }
			let (:xml) { Nokogiri.XML(void_shipment_request.to_xml) }

			it "builds xml with /VoidShipmentRequest/Request/TransactionReference/CustomerContext set to customer_context" do
				xml.at('/VoidShipmentRequest/Request/TransactionReference/CustomerContext').content.should == customer_context
			end
		end

		context "if options[:customer_context] is nil" do
			it "does not include /VoidShipmentRequest/Request/TransactionReference/CustomerContext" do
				xml.at('/VoidShipmentRequest/Request/TransactionReference/CustomerContext').should be_nil
			end
		end

		it "builds xml with /VoidShipmentRequest/ShipmentIdentificationNumber" do
			xml.at('/VoidShipmentRequest/ShipmentIdentificationNumber').content.should == shipment_identification_number
		end

		it "tests /VoidShipmentRequest/ExpandedVoidShipment"
		it "tests /VoidShipmentRequest/ExpandedVoidShipment/ShipmentIdentificationNumber"
		it "tests /VoidShipmentRequest/ExpandedVoidShipment/TrackingNumber"
	end
end




