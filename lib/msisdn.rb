
class Msisdn
  attr_accessor :original, :msisdn, :national_number, :dialing_code, :network, :country_code
  
  INTERNATIONAL_COUNTRY_CODE = /^\+(1|2[1-689]\d|2[07]|3[0-469]|3[578]\d|4[0-13-9]|42\d|5[09]\d|5[1-8]|6[0-6]|6[7-9]\d|7|8[035789]\d|8[1246]|9[0-58]|9[679]\d)(\d+)/
  INTERNATIONAL_COUNTRY_CODE_NO_PREFIX =   /(1|2[1-689]\d|2[07]|3[0-469]|3[578]\d|4[0-13-9]|42\d|5[09]\d|5[1-8]|6[0-6]|6[7-9]\d|7|8[035789]\d|8[1246]|9[0-58]|9[679]\d)(\d+)/
  EXACTLY_10_DIGITS = /^(\d{10})$/
  
  def initialize(msisdn)
    msisdn.gsub!( /[\s()\-a-zA-Z]/, '')

    
    @original = @msisdn = msisdn
    unless match_local(msisdn)
      match_international
    end
  end
  
  def to_s
    @formatted_number
  end
  
  def to_national
    @national_number
  end
  
  def to_international
    return nil if @country_code.nil?
    @msisdn
  end
  
  private
  def match_local(number)
    if number =~ EXACTLY_10_DIGITS
      @national_number = number
      if @national_number =~ INTERNATIONAL_COUNTRY_CODE_NO_PREFIX # this also works for matching local numbers
        @network = $1
      end
      return true
    end
    false
  end
  
  def match_international
    if @msisdn =~ INTERNATIONAL_COUNTRY_CODE
      @country_code, @national_number = $1, $2
      unless @national_number =~ /^0/
        @national_number = "0#{@national_number}"
      end
      match_local @national_number
    else
      match_international_no_prefix
    end
  end
  
  def match_international_no_prefix
    if @msisdn =~ INTERNATIONAL_COUNTRY_CODE_NO_PREFIX
      @country_code, @national_number = $1, $2
      unless @national_number =~ /^0/
        @national_number = "0#{@national_number}"
      end
      match_local @national_number
    end
  end
  
end