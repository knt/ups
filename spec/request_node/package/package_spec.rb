require 'spec_helper'

describe Ups::Package do

  describe '#initialize' do
    
    it "designates some parameters as required" do
      package = Ups::Package.new({})
      expect(package.instance_variable_get(:"@required_attributes")).to eq [:package_dimensions, :package_weight, :packaging_type]
    end

    it "designates some parameters as optional" do
      package  = Ups::Package.new({})
      optional = [:description, :large_package, :additional_handling]
      
      expect(package.instance_variable_get(:"@optional_attributes")).to eq optional
    end

    it "ignores unacceptable parameters" do
      package_dimensions = double(Ups::PackageDimensions)
      package_weight     = double(Ups::PackageWeight)
      packaging_type     = double(Ups::PackagingType)
      params  = {description: 'This is a package description', 
                 package_dimensions: package_dimensions, 
                 package_weight: package_weight, 
                 packaging_type: packaging_type, 
                 ringer: 'Ding Dong'}
      package = Ups::Package.new(params)
      
      expect{ package.ringer }.to raise_error NoMethodError
    end
    
  end

  describe '#validate_required' do

    it "raises an error if a required parameter is not present" do
      package_weight     = double(Ups::PackageWeight)
      packaging_type     = double(Ups::PackagingType)
      
      params  = {description: 'This is a package description', 
                 package_weight: package_weight, 
                 packaging_type: packaging_type }
      
      package = Ups::Package.new(params)    
      
      expect{ package.send(:validate_required, params) }.to raise_error RuntimeError,  "Required attribute 'package_dimensions' not set."
    end
    
  end

  describe '#to_xml' do
    let(:package_dimensions){ Ups::PackageDimensions.new() }
    let(:package_weight){ Ups::PackageWeight.new() }
    let(:packaging_type){ Ups::PackagingType.new() }
    
    let(:valid_opts){ return {package_dimensions: package_dimensions, package_weight: package_weight, packaging_type: packaging_type} }
    
    it "contains a /Package root node" do
      package = Ups::Package.new(valid_opts)
      xml     = Nokogiri.XML(package.to_xml)
      
      expect(xml.at('/Package')).to_not be_nil
    end

    it "contains required nodes and values" do
      package = Ups::Package.new(valid_opts)
      xml     = Nokogiri.XML(package.to_xml)
      
      expect(xml.at('/Package/PackagingType').to_xml).to eq valid_opts[:packaging_type].to_xml
      expect(xml.at('/Package/Dimensions').to_xml).to eq valid_opts[:package_dimensions].to_xml
      expect(xml.at('/Package/PackageWeight').to_xml).to eq valid_opts[:package_weight].to_xml
    end
 
    it "contains nodes for optional values" do
      extended_opts = valid_opts.merge({large_package: true, additional_handling: true, description: 'This is a description' })
      
      package       = Ups::Package.new(extended_opts)      
      xml           = Nokogiri.XML(package.to_xml)
      expect(xml.at('/Package/LargePackageIndicator')).to_not be_nil
      expect(xml.at('/Package/AdditionalHandling')).to_not be_nil
    end

    it "does not contain nodes for values not passed" do
      package       = Ups::Package.new(valid_opts)      
      xml           = Nokogiri.XML(package.to_xml)
      expect(xml.at('/Package/LargePackageIndicator')).to be_nil
      expect(xml.at('/Package/AdditionalHandling')).to be_nil
    end

  
  end


end
