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
      shipper.stub(:to_xml).and_return("<Shipper></Shipper>")
      shipper.stub(:shipper_number).and_return(shipper_number)
      ship_to.stub(:to_xml).and_return("<ShipTo></ShipTo>")
      package.stub(:to_xml).and_return("<Package></Package>")
    end

    it "builds xml with root node as ShipmentConfirmRequest" do
      xml.at('/ShipmentConfirmRequest').should_not be_nil
    end

    it "builds xml with /ShipmentConfirmRequest/Request" do
      xml.at('/ShipmentConfirmRequest/Request').should_not be_nil
    end

    it "builds xml with /ShipmentConfirmRequest/Request/RequestAction set to ShipConfirm" do
      xml.at('/ShipmentConfirmRequest/Request/RequestAction').content.should == "ShipConfirm"
    end

    context "if options[:request_option] present" do
      let(:request_option) { "nonvalidate" }
      let(:options) { { :request_option => request_option } }
      let (:shipment_confirm_request) { Ups::ShippingLabel::Request::ShipmentConfirmRequest.new(shipper, ship_to, service_code, packages, options) }
      let (:xml) { Nokogiri.XML(shipment_confirm_request.to_xml) }

      it "builds xml with /ShipmentConfirmRequest/Request/RequestOption set to request_option" do
        xml.at('/ShipmentConfirmRequest/Request/RequestOption').content.should == request_option
      end
    end

    context "if options[:request_option] is nil" do
      it "builds xml with /ShipmentConfirmRequest/Request/RequestOption set to validate" do
        xml.at('/ShipmentConfirmRequest/Request/RequestOption').content.should == "validate"
      end
    end

    context "if options[:customer_context] is present" do
      let(:customer_context) { "textCustomer123" }
      let(:options) { { :customer_context => customer_context } }
      let (:shipment_confirm_request) { Ups::ShippingLabel::Request::ShipmentConfirmRequest.new(shipper, ship_to, service_code, packages, options) }
      let (:xml) { Nokogiri.XML(shipment_confirm_request.to_xml) }

      it "builds xml with /ShipmentConfirmRequest/Request/TransactionReference" do
        xml.at('/ShipmentConfirmRequest/Request/TransactionReference').should_not be_nil
      end
      it "builds xml with /ShipmentConfirmRequest/Request/TransactionReference/CustomerContext set to customer_context" do
        xml.at('/ShipmentConfirmRequest/Request/TransactionReference/CustomerContext').content.should == customer_context
      end
    end

    context "if options[:customer_context] is not present" do
      it "does not include /ShipmentConfirmRequest/Request/TransactionReference node" do
        xml.at('/ShipmentConfirmRequest/Request/TransactionReference').should be_nil
      end
    end

    it "builds xml with /ShipmentConfirmRequest/Shipment" do
      xml.at('/ShipmentConfirmRequest/Shipment').should_not be_nil
    end

    context "if options[:shipment_description] is present" do
      let(:shipment_description) { "This shipment contains lots of awesome stuff"}
      let(:options) { {:shipment_description => shipment_description}}
      let (:shipment_confirm_request) { Ups::ShippingLabel::Request::ShipmentConfirmRequest.new(shipper, ship_to, service_code, packages, options) }
      let (:xml) { Nokogiri.XML(shipment_confirm_request.to_xml) }
      it "builds xml with /ShipmentConfirmRequest/Shipment/Description set to shipment_description" do
        xml.at('/ShipmentConfirmRequest/Shipment/Description').content.should == shipment_description
      end
    end

    context "if options[:shipment_description] is nil" do
      it "does not include /ShipmentConfirmRequest/Shipment/Description node" do
        xml.at('/ShipmentConfirmRequest/Shipment/Description').should be_nil
      end
    end

    it "includes shipper xml" do
      xml.at('/ShipmentConfirmRequest/Shipment/Shipper').should_not be_nil
    end

    it "includes ship_to xml" do
      xml.at('/ShipmentConfirmRequest/Shipment/ShipTo').should_not be_nil
    end

    context "if options[:ship_from] is present" do
      it "includes ship_from xml"
    end

    context "if options[:ship_from] is not present" do
      it "does not include ship_from xml"
    end

    it "builds xml with /ShipmentConfirmRequest/Shipment/PaymentInformation" do
      xml.at('/ShipmentConfirmRequest/Shipment/PaymentInformation').should_not be_nil
    end

    it "builds xml with /ShipmentConfirmRequest/Shipment/PaymentInformation/Prepaid" do
      xml.at('/ShipmentConfirmRequest/Shipment/PaymentInformation/Prepaid').should_not be_nil
    end

    it "builds xml with /ShipmentConfirmRequest/Shipment/PaymentInformation/Prepaid/BillShipper" do
      xml.at('/ShipmentConfirmRequest/Shipment/PaymentInformation/Prepaid/BillShipper').should_not be_nil
    end

    it "builds xml with /ShipmentConfirmRequest/Shipment/PaymentInformation/Prepaid/BillShipper/AccountNumber set to shipper.shipper_number" do
      xml.at('/ShipmentConfirmRequest/Shipment/PaymentInformation/Prepaid/BillShipper/AccountNumber').content.should == shipper_number
    end

    it "builds xml with /ShipmentConfirmRequest/Shipment/Service" do
      xml.at("/ShipmentConfirmRequest/Shipment/Service").should_not be_nil
    end

    it "builds xml with /ShipmentConfirmRequest/Shipment/Service/Code set to service_code" do
      xml.at("/ShipmentConfirmRequest/Shipment/Service/Code").content.should == service_code
    end

    it "builds xml with /ShipmentConfirmRequest/Shipment/Service/Description set to SERVICE_CODES[service_code]" do
      xml.at("/ShipmentConfirmRequest/Shipment/Service/Description").content.should == Ups::ShippingLabel::Request::ShipmentConfirmRequest::SERVICE_CODES[service_code]
    end

    it "builds xml with /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions" do
      xml.at("/ShipmentConfirmRequest/Shipment/ShipmentServiceOptions").should_not be_nil
    end

    context "if options[:saturday_delivery] is true" do
      let(:options) { {:saturday_delivery => true}}
      let (:shipment_confirm_request) { Ups::ShippingLabel::Request::ShipmentConfirmRequest.new(shipper, ship_to, service_code, packages, options) }
      let (:xml) { Nokogiri.XML(shipment_confirm_request.to_xml) }
      it "builds xml with /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/SaturdayDelivery" do
        xml.at('/ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/SaturdayDelivery').should_not be_nil
      end
    end

    context "if options[:saturday_delivery] is not present" do
      it "does not include node for /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/SaturdayDelivery" do
        xml.at("/ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/SaturdayDelivery").should be_nil
      end
    end

    it "includes xml for each Package in packages" do
      xml.at("/ShipmentConfirmRequest/Shipment/Package").should_not be_nil
    end

    context "if there are multiple packages in packages" do
      it "includes xml for each package"
    end

    it "builds xml with /ShipmentConfirmRequest/LabelSpecification" do
      xml.at("/ShipmentConfirmRequest/LabelSpecification").should_not be_nil
    end

    it "builds xml with /ShipmentConfirmRequest/LabelSpecification/LabelPrintMethod" do
      xml.at("/ShipmentConfirmRequest/LabelSpecification/LabelPrintMethod").should_not be_nil
    end

    context "if options[:label_print_method_code] is present" do
      let(:label_print_method_code) { :GIF }
      let(:options) { {:label_print_method_code => label_print_method_code}}
      let (:shipment_confirm_request) { Ups::ShippingLabel::Request::ShipmentConfirmRequest.new(shipper, ship_to, service_code, packages, options) }
      let (:xml) { Nokogiri.XML(shipment_confirm_request.to_xml) }
      it "builds xml with /ShipmentConfirmRequest/LabelSpecification/LabelPrintMethod/Code set to label_print_method_code" do
        xml.at("/ShipmentConfirmRequest/LabelSpecification/LabelPrintMethod/Code").content.should == label_print_method_code.to_s
      end
    end

    context "if options[:label_print_method_code] is not present" do
      it "builds xml with /ShipmentConfirmRequest/LabelSpecification/LabelPrintMethod set to DEFAULT_LABEL_PRINT_METHOD_CODE" do
        xml.at("/ShipmentConfirmRequest/LabelSpecification/LabelPrintMethod/Code").content.should == Ups::ShippingLabel::Request::ShipmentConfirmRequest::DEFAULT_LABEL_PRINT_METHOD_CODE.to_s
      end
    end

    context "if options[:label_http_user_agent] is present" do
      let(:label_http_user_agent) { "Mozilla/4.8" }
      let(:options) { {:label_http_user_agent => label_http_user_agent}}
      let (:shipment_confirm_request) { Ups::ShippingLabel::Request::ShipmentConfirmRequest.new(shipper, ship_to, service_code, packages, options) }
      let (:xml) { Nokogiri.XML(shipment_confirm_request.to_xml) }
      it "builds xml with /ShipmentConfirmRequest/LabelSpecification/HTTPUserAgent set to options[:label_http_user_agent]" do
        xml.at("/ShipmentConfirmRequest/LabelSpecification/HTTPUserAgent").content.should == label_http_user_agent
      end
    end

    context "if options[:label_http_user_agent] is not present" do
      it "builds xml with /ShipmentConfirmRequest/LabelSpecification/HTTPUserAgent set to DEFAULT_HTTP_USER_AGENT" do
        xml.at("/ShipmentConfirmRequest/LabelSpecification/HTTPUserAgent").content.should == Ups::ShippingLabel::Request::ShipmentConfirmRequest::DEFAULT_HTTP_USER_AGENT
      end
    end

    it "builds xml with /ShipmentConfirmRequest/LabelSpecification/LabelImageFormat" do
      xml.at("/ShipmentConfirmRequest/LabelSpecification/LabelImageFormat").should_not be_nil
    end

    context "if options[:label_image_format_code] is present" do
      let(:label_image_format_code) { :GIF }
      let(:options) { {:label_image_format_code => label_image_format_code}}
      let (:shipment_confirm_request) { Ups::ShippingLabel::Request::ShipmentConfirmRequest.new(shipper, ship_to, service_code, packages, options) }
      let (:xml) { Nokogiri.XML(shipment_confirm_request.to_xml) }     
      it "builds xml with /ShipmentConfirmRequest/LabelSpecification/LabelImageFormat/Code set to options[:label_image_format_code]" do
        xml.at("/ShipmentConfirmRequest/LabelSpecification/LabelImageFormat/Code").content.should == label_image_format_code.to_s
      end
    end

    context "if options[:label_image_format_code] is not present" do
      it "builds xml with /ShipmentConfirmRequest/LabelSpecification/LabelImageFormat/Code set to DEFAULT_LABEL_IMAGE_FORMAT_CODE" do
        xml.at("/ShipmentConfirmRequest/LabelSpecification/LabelImageFormat/Code").content.should == Ups::ShippingLabel::Request::ShipmentConfirmRequest::DEFAULT_LABEL_IMAGE_FORMAT_CODE.to_s
      end
    end

  end

end
























