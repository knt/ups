module Ups
  class Package < RequestNode
    attr_accessor :package_dimensions, :package_weight, :packaging_type, :description, :large_package, :additional_handling, :reference_number, :package_service_options
                  
    
    def initialize(options = {})
      super(options)
      @required_attributes  = [:package_dimensions, :package_weight, :packaging_type]
      @optional_attributes  = [:description, :large_package, :additional_handling]
    end


    def to_xml
      request = Nokogiri::XML::Builder.new do |xml|
        
        xml.Package {
          xml.LargePackageIndicator if @large_package
          xml.AdditionalHandling if @additional_handling
          xml.Description @description  unless @description.nil?
          
          xml << @reference_number.to_xml if @reference_number
          xml << @packaging_type.to_xml 
          xml << @package_dimensions.to_xml     
          xml << @package_weight.to_xml 
          xml << @package_service_options.to_xml unless @package_service_options.nil?

        }
      end

      Nokogiri::XML(request.to_xml).root.to_xml
    end
  
  end
end
