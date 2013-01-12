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
      it "includes /VoidShipmentRequest/Request/TransactionReference/CustomerContext with no content" do
        xml.at('/VoidShipmentRequest/Request/TransactionReference/CustomerContext').should_not be_nil
      end
    end

    context "if options[:tracking_numbers] is nil" do
      let(:tracking_numbers) { nil }
      let(:void_shipment_request) { Ups::ShippingLabel::Request::VoidShipmentRequest.new(shipment_identification_number, :tracking_numbers => tracking_numbers)}
      let(:xml) { Nokogiri.XML(void_shipment_request.to_xml)}

      it "builds xml with /VoidShipmentRequest/ShipmentIdentificationNumber set to shipment_identification_number" do
        xml.at('/VoidShipmentRequest/ShipmentIdentificationNumber').content.should == shipment_identification_number
      end
    end

    context "if options[:tracking_number] is not present" do
      let(:void_shipment_request) { Ups::ShippingLabel::Request::VoidShipmentRequest.new(shipment_identification_number)}
      let(:xml) { Nokogiri.XML(void_shipment_request.to_xml)}

      it "builds xml with /VoidShipmentRequest/ShipmentIdentificationNumber set to shipment_identification_number" do
        xml.at('/VoidShipmentRequest/ShipmentIdentificationNumber').content.should == shipment_identification_number
      end
    end

    context "if options[:tracking_numbers] is present and not empty" do
      let(:tracking_numbers) { ["123", "456"] }
      let(:void_shipment_request) { Ups::ShippingLabel::Request::VoidShipmentRequest.new(shipment_identification_number, :tracking_numbers => tracking_numbers)}
      let(:xml) { Nokogiri.XML(void_shipment_request.to_xml)}

      it "builds xml without /VoidShipmentRequest/ShipmentIdentificationNumber" do
        xml.at('/VoidShipmentRequest/ShipmentIdentificationNumber').should be_nil
      end

      it "builds xml with /VoidShipmentRequest/ExpandedVoidShipment" do
        xml.at('/VoidShipmentRequest/ExpandedVoidShipment').should_not be_nil
      end

      it "builds xml with /VoidShipmentRequest/ExpandedVoidShipment/ShipmentIdentificationNumber set to shipment_identification_number" do
        xml.at('/VoidShipmentRequest/ExpandedVoidShipment/ShipmentIdentificationNumber').content.should == shipment_identification_number
      end

      it "builds xml with a node /VoidShipmentRequest/TrackingNumber for each tracking number in tracking_numbers" do
        xml.xpath('/VoidShipmentRequest/ExpandedVoidShipment/TrackingNumber').should_not be_nil

        tracking_numbers_in_xml = xml.xpath('/VoidShipmentRequest/ExpandedVoidShipment/TrackingNumber').map { |node| node.content }
        tracking_numbers_in_xml.length.should == tracking_numbers.length
        tracking_numbers.each do |tracking_number|
          tracking_numbers_in_xml.should include tracking_number
        end
      end
    end
  end
end