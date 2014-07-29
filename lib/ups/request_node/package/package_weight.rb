module Ups

  class PackageWeight < RequestNode

    WEIGHT_UNITS = {
      "LBS" => "Pounds",
      "KGS" => "Kilograms",
      "00" => "Metric Unit of Measurements",
      "01" => "English Unit of Measurements"
    }
    
    attr_accessor :weight, :code

    def initialize(options = {})
      @required_attributes = [:weight, :code]
      super(options)
    end

    def to_xml
      request = Nokogiri::XML::Builder.new do |xml|
        
        xml.PackageWeight {
          xml.UnitOfMeasurement {
            xml.Code @code
            xml.Description WEIGHT_UNITS[@code]
          }

          xml.Weight @weight
        }
      end
      
      Nokogiri::XML(request.to_xml).root.to_xml
    end


  
  
  
  end

end
