module Ups
  class Package < RequestNode

    PACKAGING_TYPES = {
      "01" => "UPS Letter",
      "02" => "Customer Supplied Package",
      "03" => "Tube",
      "04" => "PAK",
      "21" => "UPS Express Box",
      "24" => "UPS 25KG Box",
      "25" => "UPS10KGBox",
      "30" => "Pallet",
      "2a" => "Small Express Box",
      "2b" => "Medium Express Box",
      "2c" => "Large Express Box"
    }

    DIMENSION_UNITS = {
      "IN" => "Inches",
      "CM" => "Centimeters",
      "00" => "Metric Units Of Measurement",
      "01" => "English Units of Measurement"
    }

    WEIGHT_UNITS = {
      "LBS" => "Pounds",
      "KGS" => "Kilograms",
      "00" => "Metric Unit of Measurements",
      "01" => "English Unit of Measurements"
    }
    attr_accessor :length, :width, :height, :weight, :description, :packaging_type_code, :large_package, :additional_handling,
                  :dimension_unit_code, :weight_unit_code
    
    def initialize(options = {})
      @required_attributes << [:length, :width, :height, :weight]
      @optional_attributes << [
                               :description, 
                               :packaging_type_code, 
                               :large_package, 
                               :additional_handling, 
                               :dimension_unit_code,
                               :weight_unit_code
                              ]
      #TODO: Move to Dimensions class

      @packaging_type_description = PACKAGING_TYPES[@packaging_type_code] unless @packaging_type_code.nil?

      #TODO: Move to Unit of Measurement class
      @dimension_unit_decription = DIMENSION_UNITS[@dimension_unit_code] unless @dimension_unit_code.nil?
      @weight_unit_description   = WEIGHT_UNITS[@weight_unit_code] unless @weight_unit_code.nil?
    end


    def to_xml
      request = Nokogiri::XML::Builder.new do |xml|
        
        xml.Package {
          xml.Description @description unless @description.nil?
          xml.PackagingType @packaging_type unless @packaging_type.nil?


          unless @packaging_type_code.nil?
            xml.PackagingType {
              xml.Code @packaging_type_code
              xml.Description @packaging_type_description
            }
          end

          xml.Dimensions {
            unless @dimension_unit_code.nil?
              xml.UnitOfMeasurement {
                xml.Code @dimension_unit_code
                xml.Description @dimension_unit_decription
              }
            end

            xml.Length @length
            xml.Width @width
            xml.Height @height
          }

          xml.PackageWeight {
            unless @weight_unit_code.nil?
              xml.UnitOfMeasurement {
                xml.Code @weight_unit_code
                xml.Description @weight_unit_description
              }
            end

            xml.Weight @weight
          }

          if @large_package
            xml.LargePackageIndicator
          end

          #TODO /Package/ReferenceNumber
          #TODO /Package/ReferenceNumber/BarCodeIndicator
          #TODO /Package/ReferenceNumber/Code
          #TODO /Package/ReferenceNumber/Value

          if @additional_handling
            xml.AdditionalHandling
          end

          #xml.PackageServiceOptions {
            #TODO /Package/PackageServiceOptions/DeliveryConfirmation/..
            #TODO /Package/PackageServiceOptions/InsuredValue/..
            #TODO /Package/PackageServiceOptions/COD/..
            #TODO /Package/PackageServiceOptions/VerbalConfirmation/..
            #TODO /Package/PackageServiceOptions/ShipperReleaseIndicator/..
            #TODO /Package/PackageServiceOptions/Notification/..
            #TODO /Package/PackageServiceOptions/ReturnsFlexibleAccessIndicator
            #TODO /Package/PackageServiceOptions/DryIce/..
          #}
        }
      end

      Nokogiri::XML(request.to_xml).root.to_xml
    end
  end
end
