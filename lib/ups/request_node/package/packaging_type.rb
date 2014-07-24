module Ups

  class PackagingType < RequestNode
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
      "2c" => "Large Express Box",
      "56" => "Flats",
      "57" => "Parcels",
      "58" => "BPM",
      "59" => "First Class",
      "60" => "Priority",
      "61" => "Machinables",
      "62" => "Irregulars",
      "63" => "Parcel",
      "64" => "BPM Parcel",
      "65" => "Media Mall",
      "66" => "BPM Flat",
      "67" => "Standard Flat"
    }
    
    attr_accessor :code

    def initialize(options = {})
      super(options)
      @required_attributes = [:code]
    end

    def to_xml
      request = Nokogiri::XML::Builder.new do |xml|

        xml.PackagingType{
          xml.Code @code
          xml.Description PACKAGING_TYPES[@code]
        }
      
      end
    end


  
  
  
  end

end
