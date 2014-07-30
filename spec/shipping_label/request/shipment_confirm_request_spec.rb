require 'spec_helper'

describe Ups::ShippingLabel::Request::ShipmentConfirmRequest do

  describe "#to_xml" do
    let (:shipper) { double(:shipper) }
    let (:ship_to) { double(:ship_to) }
    let(:shipper_number) { "shipper12345"}
    let(:service_code) { "01" }
    let(:package) { double(:package)}
    let(:packages) { [package]}
    let (:shipment_confirm_request) { Ups::ShippingLabel::Request::ShipmentConfirmRequest.new(shipper, ship_to, service_code, packages) }
    let (:xml) { Nokogiri.XML(shipment_confirm_request.to_xml) }

    before(:each) do
      allow(shipper).to receive(:to_xml).and_return("<Shipper></Shipper>")
      allow(shipper).to receive(:shipper_number).and_return(shipper_number)
      allow(ship_to).to receive(:to_xml).and_return("<ShipTo></ShipTo>")
      allow(package).to receive(:to_xml).and_return("<Package></Package>")
    end

    it "builds xml with root node as ShipmentConfirmRequest" do
      expect(xml.at('/ShipmentConfirmRequest')).not_to be_nil
    end

    it "builds xml with /ShipmentConfirmRequest/Request" do
      expect(xml.at('/ShipmentConfirmRequest/Request')).not_to be_nil
    end

    it "builds xml with /ShipmentConfirmRequest/Request/RequestAction set to ShipConfirm" do
      expect(xml.at('/ShipmentConfirmRequest/Request/RequestAction').content).to eq("ShipConfirm")
    end

    context "if options[:request_option] present" do
      let(:request_option) { "nonvalidate" }
      let(:options) { { :request_option => request_option } }
      let (:shipment_confirm_request) { Ups::ShippingLabel::Request::ShipmentConfirmRequest.new(shipper, ship_to, service_code, packages, options) }
      let (:xml) { Nokogiri.XML(shipment_confirm_request.to_xml) }

      it "builds xml with /ShipmentConfirmRequest/Request/RequestOption set to request_option" do
        expect(xml.at('/ShipmentConfirmRequest/Request/RequestOption').content).to eq(request_option)
      end
    end

    context "if options[:request_option] is nil" do
      it "builds xml with /ShipmentConfirmRequest/Request/RequestOption set to validate" do
        expect(xml.at('/ShipmentConfirmRequest/Request/RequestOption').content).to eq("validate")
      end
    end

    context "if options[:customer_context] is present" do
      let(:customer_context) { "textCustomer123" }
      let(:options) { { :customer_context => customer_context } }
      let (:shipment_confirm_request) { Ups::ShippingLabel::Request::ShipmentConfirmRequest.new(shipper, ship_to, service_code, packages, options) }
      let (:xml) { Nokogiri.XML(shipment_confirm_request.to_xml) }

      it "builds xml with /ShipmentConfirmRequest/Request/TransactionReference" do
        expect(xml.at('/ShipmentConfirmRequest/Request/TransactionReference')).not_to be_nil
      end
      it "builds xml with /ShipmentConfirmRequest/Request/TransactionReference/CustomerContext set to customer_context" do
        expect(xml.at('/ShipmentConfirmRequest/Request/TransactionReference/CustomerContext').content).to eq(customer_context)
      end
    end

    context "if options[:customer_context] is not present" do
      it "does not include /ShipmentConfirmRequest/Request/TransactionReference node" do
        expect(xml.at('/ShipmentConfirmRequest/Request/TransactionReference')).to be_nil
      end
    end

    it "builds xml with /ShipmentConfirmRequest/Shipment" do
      expect(xml.at('/ShipmentConfirmRequest/Shipment')).not_to be_nil
    end

    context "if options[:shipment_description] is present" do
      let(:shipment_description) { "This shipment contains lots of awesome stuff"}
      let(:options) { {:shipment_description => shipment_description}}
      let (:shipment_confirm_request) { Ups::ShippingLabel::Request::ShipmentConfirmRequest.new(shipper, ship_to, service_code, packages, options) }
      let (:xml) { Nokogiri.XML(shipment_confirm_request.to_xml) }
      it "builds xml with /ShipmentConfirmRequest/Shipment/Description set to shipment_description" do
        expect(xml.at('/ShipmentConfirmRequest/Shipment/Description').content).to eq(shipment_description)
      end
    end

    context "if options[:shipment_description] is nil" do
      it "does not include /ShipmentConfirmRequest/Shipment/Description node" do
        expect(xml.at('/ShipmentConfirmRequest/Shipment/Description')).to be_nil
      end
    end

    it "includes shipper xml" do
      expect(xml.at('/ShipmentConfirmRequest/Shipment/Shipper')).not_to be_nil
    end

    it "includes ship_to xml" do
      expect(xml.at('/ShipmentConfirmRequest/Shipment/ShipTo')).not_to be_nil
    end

    context "if options[:ship_from] is present" do
      it "includes ship_from xml"
    end

    context "if options[:ship_from] is not present" do
      it "does not include ship_from xml"
    end

    it "builds xml with /ShipmentConfirmRequest/Shipment/PaymentInformation" do
      expect(xml.at('/ShipmentConfirmRequest/Shipment/PaymentInformation')).not_to be_nil
    end

    it "builds xml with /ShipmentConfirmRequest/Shipment/PaymentInformation/Prepaid" do
      expect(xml.at('/ShipmentConfirmRequest/Shipment/PaymentInformation/Prepaid')).not_to be_nil
    end

    it "builds xml with /ShipmentConfirmRequest/Shipment/PaymentInformation/Prepaid/BillShipper" do
      expect(xml.at('/ShipmentConfirmRequest/Shipment/PaymentInformation/Prepaid/BillShipper')).not_to be_nil
    end

    it "builds xml with /ShipmentConfirmRequest/Shipment/PaymentInformation/Prepaid/BillShipper/AccountNumber set to shipper.shipper_number" do
      expect(xml.at('/ShipmentConfirmRequest/Shipment/PaymentInformation/Prepaid/BillShipper/AccountNumber').content).to eq(shipper_number)
    end

    it "builds xml with /ShipmentConfirmRequest/Shipment/Service" do
      expect(xml.at("/ShipmentConfirmRequest/Shipment/Service")).not_to be_nil
    end

    it "builds xml with /ShipmentConfirmRequest/Shipment/Service/Code set to service_code" do
      expect(xml.at("/ShipmentConfirmRequest/Shipment/Service/Code").content).to eq(service_code)
    end

    it "builds xml with /ShipmentConfirmRequest/Shipment/Service/Description set to SERVICE_CODES[service_code]" do
      expect(xml.at("/ShipmentConfirmRequest/Shipment/Service/Description").content).to eq(Ups::ShippingLabel::Request::ShipmentConfirmRequest::SERVICE_CODES[service_code])
    end

    it "builds xml with /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions" do
      expect(xml.at("/ShipmentConfirmRequest/Shipment/ShipmentServiceOptions")).not_to be_nil
    end

    context "if options[:saturday_delivery] is true" do
      let(:options) { {:saturday_delivery => true}}
      let (:shipment_confirm_request) { Ups::ShippingLabel::Request::ShipmentConfirmRequest.new(shipper, ship_to, service_code, packages, options) }
      let (:xml) { Nokogiri.XML(shipment_confirm_request.to_xml) }
      it "builds xml with /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/SaturdayDelivery" do
        expect(xml.at('/ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/SaturdayDelivery')).not_to be_nil
      end
    end

    context "if options[:saturday_delivery] is not present" do
      it "does not include node for /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/SaturdayDelivery" do
        expect(xml.at("/ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/SaturdayDelivery")).to be_nil
      end
    end

    it "includes xml for each Package in packages" do
      expect(xml.at("/ShipmentConfirmRequest/Shipment/Package")).not_to be_nil
    end

    context "if there are multiple packages in packages" do
      it "includes xml for each package"
    end

    it "builds xml with /ShipmentConfirmRequest/LabelSpecification" do
      expect(xml.at("/ShipmentConfirmRequest/LabelSpecification")).not_to be_nil
    end

    it "builds xml with /ShipmentConfirmRequest/LabelSpecification/LabelPrintMethod" do
      expect(xml.at("/ShipmentConfirmRequest/LabelSpecification/LabelPrintMethod")).not_to be_nil
    end

    context "if options[:label_print_method_code] is present" do
      let(:label_print_method_code) { :GIF }
      let(:options) { {:label_print_method_code => label_print_method_code}}
      let (:shipment_confirm_request) { Ups::ShippingLabel::Request::ShipmentConfirmRequest.new(shipper, ship_to, service_code, packages, options) }
      let (:xml) { Nokogiri.XML(shipment_confirm_request.to_xml) }
      it "builds xml with /ShipmentConfirmRequest/LabelSpecification/LabelPrintMethod/Code set to label_print_method_code" do
        expect(xml.at("/ShipmentConfirmRequest/LabelSpecification/LabelPrintMethod/Code").content).to eq(label_print_method_code.to_s)
      end
    end

    context "if options[:label_print_method_code] is not present" do
      it "builds xml with /ShipmentConfirmRequest/LabelSpecification/LabelPrintMethod set to DEFAULT_LABEL_PRINT_METHOD_CODE" do
        expect(xml.at("/ShipmentConfirmRequest/LabelSpecification/LabelPrintMethod/Code").content).to eq(Ups::ShippingLabel::Request::ShipmentConfirmRequest::DEFAULT_LABEL_PRINT_METHOD_CODE.to_s)
      end
    end

    context "if options[:label_http_user_agent] is present" do
      let(:label_http_user_agent) { "Mozilla/4.8" }
      let(:options) { {:label_http_user_agent => label_http_user_agent}}
      let (:shipment_confirm_request) { Ups::ShippingLabel::Request::ShipmentConfirmRequest.new(shipper, ship_to, service_code, packages, options) }
      let (:xml) { Nokogiri.XML(shipment_confirm_request.to_xml) }
      it "builds xml with /ShipmentConfirmRequest/LabelSpecification/HTTPUserAgent set to options[:label_http_user_agent]" do
        expect(xml.at("/ShipmentConfirmRequest/LabelSpecification/HTTPUserAgent").content).to eq(label_http_user_agent)
      end
    end

    context "if options[:label_http_user_agent] is not present" do
      it "builds xml with /ShipmentConfirmRequest/LabelSpecification/HTTPUserAgent set to DEFAULT_HTTP_USER_AGENT" do
        expect(xml.at("/ShipmentConfirmRequest/LabelSpecification/HTTPUserAgent").content).to eq(Ups::ShippingLabel::Request::ShipmentConfirmRequest::DEFAULT_HTTP_USER_AGENT)
      end
    end

    it "builds xml with /ShipmentConfirmRequest/LabelSpecification/LabelImageFormat" do
      expect(xml.at("/ShipmentConfirmRequest/LabelSpecification/LabelImageFormat")).not_to be_nil
    end

    context "if options[:label_image_format_code] is present" do
      let(:label_image_format_code) { :GIF }
      let(:options) { {:label_image_format_code => label_image_format_code}}
      let (:shipment_confirm_request) { Ups::ShippingLabel::Request::ShipmentConfirmRequest.new(shipper, ship_to, service_code, packages, options) }
      let (:xml) { Nokogiri.XML(shipment_confirm_request.to_xml) }
      it "builds xml with /ShipmentConfirmRequest/LabelSpecification/LabelImageFormat/Code set to options[:label_image_format_code]" do
        expect(xml.at("/ShipmentConfirmRequest/LabelSpecification/LabelImageFormat/Code").content).to eq(label_image_format_code.to_s)
      end
    end

    context "if options[:label_image_format_code] is not present" do
      it "builds xml with /ShipmentConfirmRequest/LabelSpecification/LabelImageFormat/Code set to DEFAULT_LABEL_IMAGE_FORMAT_CODE" do
        expect(xml.at("/ShipmentConfirmRequest/LabelSpecification/LabelImageFormat/Code").content).to eq(Ups::ShippingLabel::Request::ShipmentConfirmRequest::DEFAULT_LABEL_IMAGE_FORMAT_CODE.to_s)
      end
    end

  end

end