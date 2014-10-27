# Handles HTTP Requests to Amazon Product Advertising API
# More info: http://docs.aws.amazon.com/AWSECommerceService/latest/DG/rest-signature.html

module Amazon

  require 'cgi'
  require "addressable/uri"

  class Amazon
    attr_reader :product_info

    ACCESS_KEY = ENV["AMZN_ACCESS_KEY"]
    SECRET_KEY = ENV["AMZN_SECRET_KEY"]

    @product_info ={}

    def initialize(asin, aff_tag)
      @product_info = {
        asin: asin,
        aff_tag: aff_tag,
        amzn_url: clean_amzn_url(asin),
        amzn_aff_url: amzn_aff_url(asin, aff_tag)
      }
      add_amazon_info
    end

    # Gets the Amazon response from the request
    # Input: hash of strings
    # Output: XML
    def get_xml(asin = @product_info[:asin], aff_tag = @product_info[:aff_tag])
      HTTParty.get(signed_request(@product_info[:asin], @product_info[:aff_tag]))
    end

    private

    # Returns product url without quary params (this is not an affiliate link)
    # Input: string, string
    # Output: string
    def clean_amzn_url(asin)
      "http://www.amazon.com/gp/product/#{asin}"
    end

    # Returns product affiliate url
    # Input: string, string
    # Output: string
    def amzn_aff_url(asin, aff_tag)
      "http://www.amazon.com/gp/product/#{asin}/?tag=#{aff_tag}"
    end

    # Creates the query string
    # Input: none
    # Output: string
    def query (item_id, affiliate_tag)
      uri = Addressable::URI.new

      uri.query_values = {
        AWSAccessKeyId: ACCESS_KEY.to_s,
        AssociateTag: affiliate_tag,
        ItemId: item_id,
        Version: Time.now.getutc.strftime("%F"),
        Timestamp: Time.now.getutc.strftime("%FT%TZ"),
        Operation: "ItemLookup",
        ResponseGroup: "ItemAttributes,Images,Reviews,Similarities,SalesRank",
        Service: "AWSECommerceService"
      }

      uri.query.gsub(':', '%3A').gsub(',', '%2C')
    end

    # Creates unsigned request, to be used for signature
    # Input: string
    # Output: string
    def unsigned_request(query)
      ['GET', 'webservices.amazon.com', '/onca/xml', query].join("\n")
    end

    # Creates signature
    # Input: string
    # Output: string
    def generate_signature(unsigned_request)
      Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::SHA256.new, SECRET_KEY, unsigned_request)).gsub('+', '%2B').gsub('+', '%3d')
    end

    # Constructs the HTTP request
    # Input: none
    # Output: string
    def signed_request(item_id, affiliate_tag)
      "http://webservices.amazon.com/onca/xml?" + query(item_id, affiliate_tag) + "&Signature=#{generate_signature(unsigned_request(query(item_id, affiliate_tag)))}"
    end

    # Parses the amazon response to a hash
    # Input: xml
    # Output: hash of strings
    def get_params(xml)
      {
        amzn_url: xml["ItemLookupResponse"]["Items"]["Item"]["DetailPageURL"],
        name: xml["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Title"],
        sm_img_url: xml["ItemLookupResponse"]["Items"]["Item"]["SmallImage"]["URL"],
        med_img_url: xml["ItemLookupResponse"]["Items"]["Item"]["MediumImage"]["URL"],
        lg_img_url:xml["ItemLookupResponse"]["Items"]["Item"]["LargeImage"]["URL"],
        reviews_url: xml["ItemLookupResponse"]["Items"]["Item"]["CustomerReviews"]["IFrameURL"],
        sales_rank: xml["ItemLookupResponse"]["Items"]["Item"]["SalesRank"]
      }
    end

    # Calls the Amazon API and adds the extra params in the @product_info hash
    # Input: none
    # Output: hash
    def add_amazon_info
      @product_info = @product_info.merge(get_params(get_xml(@product_info[:asin], @product_info[:aff_tag])))
    end
  end


  # ACCESS_KEY = ENV["AMZN_ACCESS_KEY"]
  # SECRET_KEY = ENV["AMZN_SECRET_KEY"]

  # # Creates the query string
  # # Input: none
  # # Output: string
  # def query (item_id, affiliate_tag)
  #   uri = Addressable::URI.new

  #   uri.query_values = {
  #     AWSAccessKeyId: ACCESS_KEY.to_s,
  #     AssociateTag: affiliate_tag,
  #     ItemId: item_id,
  #     Version: Time.now.getutc.strftime("%F"),
  #     Timestamp: Time.now.getutc.strftime("%FT%TZ"),
  #     Operation: "ItemLookup",
  #     ResponseGroup: "ItemAttributes,Images,Reviews,SalesRank",
  #     Service: "AWSECommerceService"
  #   }

  #   uri.query.gsub(':', '%3A').gsub(',', '%2C')
  # end

  # # Creates unsigned request, to be used for signature
  # # Input: string
  # # Output: string
  # def unsigned_request(query)
  #   ['GET', 'webservices.amazon.com', '/onca/xml', query].join("\n")
  # end

  # # Creates signature
  # # Input: string
  # # Output: string
  # def generate_signature(unsigned_request)
  #   Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::SHA256.new, SECRET_KEY, unsigned_request)).gsub('+', '%2B').gsub('+', '%3d')
  # end

  # # Constructs the HTTP request
  # # Input: none
  # # Output: string
  # def signed_request(item_id, affiliate_tag)
  #   "http://webservices.amazon.com/onca/xml?" + query(item_id, affiliate_tag) + "&Signature=#{generate_signature(unsigned_request(query(item_id, affiliate_tag)))}"
  # end

  # # Gets the Amazon response from the request
  # # Input: hash of strings
  # # Output: XML
  # def get_xml(item_id, affiliate_tag)
  #   HTTParty.get(signed_request(item_id, affiliate_tag))
  # end

  # # Parses the amazon response to a hash
  # # Input: xml
  # # Output: hash of strings
  # def get_params(xml)
  #   {
  #     amzn_url: xml["ItemLookupResponse"]["Items"]["Item"]["DetailPageURL"],
  #     name: xml["ItemLookupResponse"]["Items"]["Item"]["ItemAttributes"]["Title"],
  #     sm_img_url: xml["ItemLookupResponse"]["Items"]["Item"]["SmallImage"]["URL"],
  #     med_img_url: xml["ItemLookupResponse"]["Items"]["Item"]["MediumImage"]["URL"],
  #     lg_img_url:xml["ItemLookupResponse"]["Items"]["Item"]["LargeImage"]["URL"],
  #     reviews_url: xml["ItemLookupResponse"]["Items"]["Item"]["CustomerReviews"]["IFrameURL"],
  #     sales_rank: xml["ItemLookupResponse"]["Items"]["Item"]["SalesRank"]
  #   }
  # end

end

