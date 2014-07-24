module Ups

  class ReferenceNumber < RequestNode
    
    REFERENCE_NUMBER_TYPES = {
      '3Q'    => 'FDA Product Code',
      'AJ'    => 'Accounts Receivable Customer Account',
      'AT'    => 'Appropriation Number',
      'BM'    => 'Bill of Lading',
      'DP'    => 'Department Number',
      'EI'    => 'Employers Identification Number',
      'IK'    => 'Invoice Number',
      'MJ'    => 'Model Number',
      'MK'    => 'Manifest Key Number',
      'ON'    => 'Dealer Order Number',
      'PC'    => 'Production Code',
      'PM'    => 'Part Number Code',
      'PO'    => 'Purchase Order Number',
      'RQ'    => 'Purchase Requisition Number',
      'SA'    => 'Salesperson',
      'SE'    => 'Serial Number',
      'ST'    => 'Store Number',
      'SY'    => 'Social Security Number',
      'TJ'    => 'Federal Tax ID',
      'TN'    => 'Transaction Reference Number'
    }
    
    attr_accessor :type_code, :barcode, :value

    def initialize(options = {})
      super(options)
      @required_attributes = [:type_code, :value]
    end

    def to_xml
      
      request = Nokogiri::XML::Builder.new do |xml|

        xml.ReferenceNumber{
          xml.Code @code
          xml.Value @value
          xml.BarCodeIndicator if @barcode
        }
      
      end
    end


  
  
  
  end

end
