require 'ups/shipping_label/request/base'

module Ups
  module ShippingLabel
    module Request
      class ShipmentConfirmRequest < Base

        REQUEST_ACTION = "ShipConfirm"

        REQUEST_OPTIONS = [:validate, :nonvalidate]
        DEFAULT_REQUEST_OPTION = :validate

        attr_accessor :shipper, :ship_to, :ship_from

        SERVICE_CODES = { "01" => "Next Day Air",
                  "02" => "2nd Day Air098 ",
                  "03" => "Ground",
                  "07" => "Express",
                  "08" => "Expedited",
                  "11" => "UPS Standard",
                  "12" => "3 Day Select",
                  "13" => "Next Day Air Save",
                  "14" => "Next Day Air Early AM",
                  "54" => "Express Plus",
                  "59" => "2nd Day Air A.M.",
                  "65" => "UPS Saver",
                  "82" => "UPS Today Standard",
                  "83" => "UPS Today Dedicated Courier",
                  "84" => "UPS Today Intercity",
                  "85" => "UPS Today Express",
                  "86" => "UPS Today Express Saver"}

        LABEL_PRINT_METHOD_CODES = ["GIF", "EPL", "ZPL", "STARPL", "SP"]
        LABEL_IMAGE_FORMAT_CODES = ["GIF", "PNG"]
        DEFAULT_LABEL_PRINT_METHOD_CODE = "GIF"
        DEFAULT_LABEL_IMAGE_FORMAT_CODE = "GIF"
        DEFAULT_HTTP_USER_AGENT = "Mozilla/4.5"

        def initialize(shipper, ship_to, service_code, packages, options={})
          #TODO: check to make sure its of type Shipper
          @shipper = shipper
          @ship_to = ship_to
          @packages = packages  #TODO: Validate that each is of type package

          @request_option = options[:request_option] || DEFAULT_REQUEST_OPTION
          @customer_context = options[:customer_context]
          @shipment_description = options[:shipment_description]
          @ship_from = options[:ship_from]

          @service_code = service_code
          @service_description = SERVICE_CODES[@service_code]

          @saturday_delivery = options[:saturday_delivery] == true

          @label_print_method_code = options[:label_print_method_code] || DEFAULT_LABEL_PRINT_METHOD_CODE
          @label_http_user_agent = options[:label_http_user_agent] || DEFAULT_HTTP_USER_AGENT

          @label_image_format_code = options[:label_image_format_code] || DEFAULT_LABEL_IMAGE_FORMAT_CODE
        end


        def to_xml
          request = Nokogiri::XML::Builder.new do |xml|
            xml.ShipmentConfirmRequest {
              xml.Request {
                xml.RequestAction REQUEST_ACTION
                xml.RequestOption @request_option

                unless @customer_context.nil?
                  xml.TransactionReference {
                    xml.CustomerContext @customer_context
                  }
                end
              }

              xml.Shipment {
                unless @shipment_description.nil?
                  xml.Description @shipment_description
                end
                
                #TODO: /ShipmentConfirmRequest/Shipment/ReturnService
                #TODO: /ShipmentConfirmRequest/Shipment/ReturnService/Code
                #TODO: /ShipmentConfirmRequest/Shipment/DocumentsOnly

                xml << shipper.to_xml

                xml << ship_to.to_xml

                unless @ship_from.nil?
                  xml << ship_from.to_xml
                end

                #TODO: Implement /ShipmentConfirmRequest/Shipment/SoldTo
                #TODO: Implement /ShipmentConfirmRequest/Shipment/SoldTo/Option
                #TODO: Implement /ShipmentConfirmRequest/Shipment/SoldTo/CompanyName
                #TODO: Implement /ShipmentConfirmRequest/Shipment/SoldTo/AttentionName
                #TODO: Implement /ShipmentConfirmRequest/Shipment/SoldTo/TaxIdentificationNumber
                #TODO: Implement /ShipmentConfirmRequest/Shipment/SoldTo/PhoneNumber
                #TODO: Implement /ShipmentConfirmRequest/Shipment/SoldTo/Address

                #Either PaymentInformation or ItemizedPaymentInformation must be supplied (but not both)
                xml.PaymentInformation {
                  #Prepaid, BilLThirdParty, or FreightCollect must be present
                  #Right now only Prepaid with Account Number is implemented
                  xml.Prepaid {
                    xml.BillShipper {
                      xml.AccountNumber shipper.shipper_number

                      #TODO: If AccountNumber is not present, provide Credit Card information
                      #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/Prepaid/BillShipper/CreditCard
                      #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/Prepaid/BillShipper/CreditCard/Type
                      #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/Prepaid/BillShipper/CreditCard/Number
                      #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/Prepaid/BillShipper/CreditCard/ExpirationDate
                      #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/Prepaid/BillShipper/CreditCard/SecurityCode
                      #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/Prepaid/BillShipper/CreditCard/Address
                      #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/Prepaid/BillShipper/CreditCard/Address/AddressLine1
                      #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/Prepaid/BillShipper/CreditCard/Address/AddressLine2
                      #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/Prepaid/BillShipper/CreditCard/Address/AddressLine3
                      #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/Prepaid/BillShipper/CreditCard/Address/City
                      #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/Prepaid/BillShipper/CreditCard/Address/StateProvinceCode
                      #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/Prepaid/BillShipper/CreditCard/Address/PostalCode
                      #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/Prepaid/BillShipper/CreditCard/Address/CountryCode
                   }

                  }

                  #TODO: BillThirdParty
                  #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/BillThirdParty
                  #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/BillThirdParty/BillThirdPartyShipper
                  #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/BillThirdParty/BillThirdPartyShipper/AccountNumber
                  #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/BillThirdParty/BillThirdPartyShipper/ThirdParty
                  #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/BillThirdParty/BillThirdPartyShipper/ThirdParty/Address
                  #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/BillThirdParty/BillThirdPartyShi pper/ThirdParty/Address/PostalCode
                  #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/BillThirdParty/BillThirdPartyShi pper/ThirdParty/Address/CountryCode

                  #TODO: FreightCollect
                  #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/FreightCollect
                  #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/FreightCollect/BillReceiver
                  #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/FreightCollect/BillReceiver/AccountNumber
                  #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/FreightCollect/BillReceiver/Address
                  #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/FreightCollect/BillReceiver/Address/PostalCode

                  #TODO: /ShipmentConfirmRequest/Shipment/PaymentInformation/ConsigneeBilled
                }

                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/Type

                #If ItemizedPaymentInformation is present, BillShipper, BillThirdParty, or ConsignedBill must be present
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillShipper
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillShipper/AccountNumber
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillShipper/CreditCard
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillShipper/CreditCard/Type
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillShipper/CreditCard/Number
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillShipper/CreditCard/ExpirationDate
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillShipper/CreditCard/SecurityCode
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillShipper/CreditCard/Address
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillShipper/CreditCard/Address/AddressLine1
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillShipper/CreditCard/Address/AddressLine2
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillShipper/CreditCard/Address/AddressLine3
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillShipper/CreditCard/Address/City
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillShipper/CreditCard/Address/StateProvinceCo de
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillShipper/CreditCard/Address/PostalCode
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillShipper/CreditCard/Address/CountryCode
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillReceiver
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillReceiver/AccountNumber
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillReceiver/AccountNumber
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillReceiver/Address/PostalCode
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillThirdParty
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillThirdParty/BillThirdPartyShipper
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillThirdParty/BillThirdPartyShipper/AccountNum ber
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillThirdParty/BillThirdPartyShipper/ThirdParty
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillThirdParty/BillThirdPartyShipper/ThirdParty/Address
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillThirdParty/BillThirdPartyShipper/ThirdParty/Address/PostalCode
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillThirdParty/BillThirdPartyShipper/ThirdParty/Address/CountryCode
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillThirdParty/BillThirdPartyConsignee
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillThirdParty/BillThirdPartyConsignee/AccountNumber
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillThirdParty/BillThirdPartyConsignee/ThirdParty
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillThirdParty/BillThirdPartyConsignee/ThirdParty/Address
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/BillThirdParty/BillThirdPartyConsignee/ThirdParty/Address/PostalCode
                #TODO /ShipmentConfirmRequest/Shipment/ItemizePaymentInformation/ShipmentCharge/BillThirdParty/BillThirdPartyConsignee/ThirdParty/Address/CountryCode
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/ShipmentCharge/ConsigneeBilled
                #TODO /ShipmentConfirmRequest/Shipment/ItemizedPaymentInformation/SplitDutyVATIndicator
                #TODO /ShipmentConfirmRequest/Shipment/GoodsNotInFreeCirculationIndicator

                #TODO /ShipmentConfirmRequest/Shipment/RateInformation
                #TODO /ShipmentConfirmRequest/Shipment/RateInformation/NegotiatedRatesIndicator
                #TODO /ShipmentConfirmRequest/Shipment/RateInformation/RateChartIndicator
                #TODO /ShipmentConfirmRequest/Shipment/MovementReferenceNumber

                #TODO /ShipmentConfirmRequest/Shipment/ReferenceNumber
                #TODO /ShipmentConfirmRequest/Shipment/ReferenceNumber/BarCodeIndicator
                #TODO /ShipmentConfirmRequest/Shipment/ReferenceNumber/Code
                #TODO /ShipmentConfirmRequest/Shipment/ReferenceNumber/Value


                xml.Service {
                  xml.Code @service_code
                  xml.Description @service_description
                }

                #TODO /ShipmentConfirmRequest/Shipment/InvoiceLineTotal
                #TODO /ShipmentConfirmRequest/Shipment/InvoiceLineTotal/CurrencyCode
                #TODO /ShipmentConfirmRequest/Shipment/InvoiceLineTotal/MonetaryValue

                xml.ShipmentServiceOptions {
                  if @saturday_delivery
                    xml.SaturdayDelivery
                  end

                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/COD
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/COD/CODCode
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/COD/CODFundsCode
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/COD/CODAmount
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/COD/CODAmount/CurrencyCode
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/COD/CODAmount/MonetaryValue

                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/Notification
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/Notification/NotificationCode
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/Notification/EMailMessage
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/Notification/EMailMessage/EMailAddress
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/Notification/EMailMessage/UndeliverableEMailAddress
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/Notification/EMailMessage/FromEMailAddress
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/Notification/EMailMessage/FromName
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/Notification/EMailMessage/Memo
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/Notification/EMailMessage/Subject
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/Notification/EMailMessage/SubjectCode

                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/LabelDelivery
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/LabelDelivery/EMailMessage
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/LabelDelivery/EMailMessage/EMailAddress
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/LabelDelivery/EMailMessage/UndeliverableEMailAddress
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/LabelDelivery/EMailMessage/FromEMailAddress
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/LabelDelivery/EMailMessage/FromName
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/LabelDelivery/EMailMessage/Memo
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/LabelDelivery/EMailMessage/Subject
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/LabelDelivery/EMailMessage/SubjectCode

                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/LabelDelivery/LabelLinksIndicator

                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/InternationalForms/...


                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/ReturnOfDocumentIndicator
                  
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/DeliveryConfirmation
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/DeliveryConfirmation/DCISType
                  
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/ImportControlIndicator
                  
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/LabelMethod
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/LabelMethod/Code
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/LabelMethod/Description

                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/CommercialInvoiceRemovalIndicator
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/UPScarbonneutralIndicator
                  #TODO /ShipmentConfirmRequest/Shipment/ShipmentServiceOptions/PreAlertNotification/..
                }

                @packages.each do |package|
                  xml << package.to_xml
                end


                xml.LabelSpecification {
                  xml.LabelPrintMethod {
                    xml.Code @label_print_method_code
                  }

                  xml.HTTPUserAgent @label_http_user_agent

                  #For EPL2, ZPL, STARPL or SPL labels
                  # xml.LabelStockSize {
                  #   xml.Height @label_stock_size_height
                  #   xml.Width @label_stock_size_width
                  # }

                  #Valid formats are GIF or PNG
                  xml.LabelImageFormat {
                    xml.Code @label_image_format_code
                  }

                  #TODO /ShipmentConfirmRequest/LabelSpecification/Instruction
                  #TODO /ShipmentConfirmRequest/LabelSpecification/Instruction/Code
                  #TODO /ShipmentConfirmRequest/LabelSpecification/Instruction/Description
                }

                #TODO /ShipmentConfirmRequest/ReceiptSpecification
                #TODO /ShipmentConfirmRequest/ReceiptSpecification/ImageFormat
                #TODO /ShipmentConfirmRequest/ReceiptSpecification/ImageFormat/Code
                #TODO /ShipmentConfirmRequest/ReceiptSpecification/ImageFormat/Description
                #ZOMG IM DONE


              }

            }

          end

          request.to_xml
        end
      end
    end
  end
end