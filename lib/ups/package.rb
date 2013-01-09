module Ups
  class Package

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

  	DIMENSION_UNITS_OF_MEASUREMENT = {
  		"IN" => "Inches", 
  		"CM" => "Centimeters", 
  		"00" => "Metric Units Of Measurement", 
  		"01" => "English Units of Measurement"
  	}

  	WEIGHT_UNITS_OF_MEASUREMENT = {
  		"LBS" => "Pounds", 
  		"KGS" => "Kilograms", 
  		"00" => "Metric Unit of Measurements", 
  		"01" => "English Unit of Measurements"
  	}

  	def initialize(length, width, height, weight, options={})
  		#TODO: Move to Dimensions class
  		@length = length
  		@width = width
  		@height = height
  		@weight = weight

  		@description = options[:description]
  		@packaging_type_code = options[:packaging_type_code]
  		@packaging_type_description = PACKAGING_TYPES[@packaging_type_code] unless @packaging_type_code.nil?

  		#TODO: Move to Unit of Measurement class
  		@dimension_unit_of_measurement_code = options[:dimension_unit_of_measurement_code]
  		@dimension_unit_of_measurement_decription = DIMENSION_UNITS_OF_MEASUREMENT[@unit_of_measurement_code] unless @unit_of_measurement_code.nil?
  		@weight_unit_of_measurement_code = options[:weight_unit_of_measurement_code]
  		@weight_unit_of_measurement_description = WEIGHT_UNITS_OF_MEASUREMENT[@weight_unit_of_measurement_description] unless @unit_of_measurement_code.nil?

  		@large_package = options[:large_package] == true
  		@additional_handling = options[:additional_handling] == true
  	end


  	def to_xml
  		request = Nokogiri::XML::Builder.new do |xml|
	  		xml.Package {

	  			unless @description.nil?
	  				xml.Description @description
	  			end

	  			unless @packaging_type_code.nil?
	  				xml.PackagingType {
	  					xml.Code @packaging_type_code
	  					xml.Description @packaging_type_description
	  				}
	  			end

	  			xml.Dimensions {
	  				unless @dimension_unit_of_measurement_code.nil?
	  					xml.UnitOfMeasurement {
	  						xml.Code @dimension_unit_of_measurement_code
	  						xml.Description @dimension_unit_of_measurement_decription
	  					}
	  				end

	  				xml.Length @length
	  				xml.Width @width
	  				xml.Height @height
	  			}

	  			xml.PackageWeight {
	  				unless @weight_unit_of_measurement_code.nil?
	  					xml.UnitOfMeasurement {
	  						xml.Code @weight_unit_of_measurement_code
	  						xml.Description @dimension_unit_of_measurement_decription
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

	  			unless @additional_handling.nil?
	  				xml.AdditionalHandling
	  			end

	  			xml.PackageServiceOptions {
	  				#TODO /Package/PackageServiceOptions/DeliveryConfirmation/..
	  				#TODO /Package/PackageServiceOptions/InsuredValue/..
	  				#TODO /Package/PackageServiceOptions/COD/..
	  				#TODO /Package/PackageServiceOptions/VerbalConfirmation/..
	  				#TODO /Package/PackageServiceOptions/ShipperReleaseIndicator/..
	  				#TODO /Package/PackageServiceOptions/Notification/..
	  				#TODO /Package/PackageServiceOptions/ReturnsFlexibleAccessIndicator
	  				#TODO /Package/PackageServiceOptions/DryIce/..
	  			}
	  		}
	  	end

	  	Nokogiri::XML(request.to_xml).root.to_xml
	  end
  end
end	