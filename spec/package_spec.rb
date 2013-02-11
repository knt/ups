require 'spec_helper'

describe Ups::Package do

  let(:length) { 5 }
  let(:width) { 6 }
  let(:height) { 7}
  let(:weight) { 1.5 }
  let(:options) { {} }
  let(:package) { Ups::Package.new(length, width, height, weight, options)}

  describe "#to_xml" do
    let(:xml) { Nokogiri.XML(package.to_xml)}

    it "builds xml with a /Package node" do
      xml.at("/Package").should_not be_nil
    end

    context "if options[:description] is present" do
      let(:description) { "This is a super awesome package" }
      let(:options) { {:description => description} }
      let(:package) { Ups::Package.new(length, width, height, weight, options)}
      let(:xml) { Nokogiri.XML(package.to_xml)}

      it "sets the /Package/Description node to description" do
        xml.at("/Package/Description").content.should == description
      end
    end

    context "if options[:description] is not present" do
      it "does not include /Package/Description node" do
        xml.at("/Package/Description").should be_nil
      end
    end

    context "if options[:packaging_type_code] is present" do
      let(:packaging_type_code) { "01" }
      let(:options) { {:packaging_type_code => packaging_type_code} }
      let(:package) { Ups::Package.new(length, width, height, weight, options)}
      let(:xml) { Nokogiri.XML(package.to_xml)}

      it "includes node for /Package/PackagingType" do
        xml.at("/Package/PackagingType").should_not be_nil
      end

      it "sets the /Package/PackagingType/Code node to packaging_type_code" do
        xml.at("/Package/PackagingType/Code").content.should == packaging_type_code
      end

      it "sets the /Packaging/PackagingType/Description node to value of Package::PACKAGING_TYPES[packaging_type_code]" do
        xml.at("/Package/PackagingType/Description").content.should == Ups::Package::PACKAGING_TYPES[packaging_type_code]
      end
    end

    context "if options[:packaging_type_code] is not present" do
      it "does not include node for /Package/PackagingType" do
        xml.at("/Package/PackagingType").should be_nil
      end
    end

    it "includes /Package/Dimensions node" do
      xml.at("/Package/Dimensions").should_not be_nil
    end

    context "if options[:dimension_unit_of_measurement_code] is present" do
      let(:dimension_unit_of_measurement_code) { "IN" }
      let(:options) { {:dimension_unit_of_measurement_code => dimension_unit_of_measurement_code} }
      let(:package) { Ups::Package.new(length, width, height, weight, options)}
      let(:xml) { Nokogiri.XML(package.to_xml)}

      it "includes node for /Package/Dimensions/UnitOfMeasurement" do
        xml.at("/Package/Dimensions/UnitOfMeasurement").should_not be_nil
      end

      it "sets /Package/Dimensions/UnitOfMeasurement/Code to dimension_unit_of_measurement_code" do
        xml.at("/Package/Dimensions/UnitOfMeasurement/Code").content.should == dimension_unit_of_measurement_code
      end

      it "sets /Package/Dimensions/UnitOfMeasurement/Description to Ups::Package::DIMENSION_UNITS_OF_MEASUREMENT[dimension_unit_of_measurement_code]" do
        xml.at("/Package/Dimensions/UnitOfMeasurement/Description").content.should == Ups::Package::DIMENSION_UNITS_OF_MEASUREMENT[dimension_unit_of_measurement_code]
      end
    end

    context "if options[:dimension_unit_of_measurement_code] is not present" do
      it "does not include node for /Package/Dimensions/UnitOfMeasurement" do
        xml.at("/Package/Dimensions/UnitOfMeasurement").should be_nil
      end
    end

    it "sets /Package/Dimensions/Length to length" do
      xml.at("/Package/Dimensions/Length").content.should == length.to_s
    end

    it "sets /Package/Dimensions/Width to width" do
      xml.at("/Package/Dimensions/Width").content.should == width.to_s
    end

    it "sets /Package/Dimensions/Height to height" do
      xml.at("/Package/Dimensions/Height").content.should == height.to_s
    end

    context "if options[:weight_unit_of_measurement_code] is present" do
      let(:weight_unit_of_measurement_code) { "LBS" }
      let(:options) { {:weight_unit_of_measurement_code => weight_unit_of_measurement_code} }
      let(:package) { Ups::Package.new(length, width, height, weight, options)}
      let(:xml) { Nokogiri.XML(package.to_xml)}

      it "includes node for /Package/PackageWeight/UnitOfMeasurement" do
        xml.at("/Package/PackageWeight/UnitOfMeasurement").should_not be_nil
      end

      it "sets /Package/PackageWeight/UnitOfMeasurement/Code to weight_unit_of_measurement_code" do
        xml.at("/Package/PackageWeight/UnitOfMeasurement/Code").content.should == weight_unit_of_measurement_code
      end

      it "sets /Package/PackageWeight/UnitOfMeasurement/Description to Ups::Package::WEIGHT_UNITS_OF_MEASUREMENT[weight_unit_of_measurement_code]" do
        xml.at("/Package/PackageWeight/UnitOfMeasurement/Description").content.should == Ups::Package::WEIGHT_UNITS_OF_MEASUREMENT[weight_unit_of_measurement_code]
      end
    end

    it "sets /Package/PackageWeight/Weight to weight" do
      xml.at("/Package/PackageWeight/Weight").content.should == weight.to_s
    end

    context "if options[:large_package] is true" do
      let(:options) { {:large_package => true } }
      let(:package) { Ups::Package.new(length, width, height, weight, options) }
      it "includes node for LargePackageIndicator" do
        xml.at("/Package/LargePackageIndicator").should_not be_nil
      end
    end

    context "if options[:large_package] is not true" do
      let(:options) { {:large_package => false} }
      let(:package) { Ups::Package.new(length, width, height, weight, options) }
      it "does not include node for LargePacakgeIndicator" do
        xml.at("/Package/LargePackageIndicator").should be_nil
      end
    end
    
    context "if options[:large_package] is not present" do
      let(:options) { {} }
      let(:package) { Ups::Package.new(length, width, height, weight, options) }
      it "does not include node for LargePacakgeIndicator" do
        xml.at("/Package/LargePackageIndicator").should be_nil
      end
    end

    context "if options[:additional_handling] is true" do
      let(:options) { {:additional_handling => true } }
      let(:package) { Ups::Package.new(length, width, height, weight, options) }
      it "includes node for AdditionalHandling" do
        xml.at("/Package/AdditionalHandling").should_not be_nil
      end
    end

    context "if options[:additional_handling] is not true" do
      let(:options) { {:additional_handling => false} }
      let(:package) { Ups::Package.new(length, width, height, weight, options) }
      it "does not include node for AdditionalHandling" do
        xml.at("/Package/AdditionalHandling").should be_nil
      end
    end
    
    context "if options[:additional_handling] is not present" do
      let(:options) { {} }
      let(:package) { Ups::Package.new(length, width, height, weight, options) }
      it "does not include node for AdditionalHandling" do
        xml.at("/Package/AdditionalHandling").should be_nil
      end
    end

    it "includes node for PackageServiceOptions" do
      xml.at("/Package/PackageServiceOptions").should_not be_nil
    end
  end

end
