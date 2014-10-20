# Handles HTTP Requests to Amazon Product Advertising API

# More info: http://docs.aws.amazon.com/AWSECommerceService/latest/DG/rest-signature.html

# How to use
# a = Amazon.new
# a.get("B00LFEHN96", "georbani-20")

module Amazon
  require 'HTTParty'
  require 'cgi'
  require 'pry'
  require "addressable/uri"

  ACCESS_KEY = ENV["AMAZON_ACCESS_KEY"]
  SECRET_KEY = ENV["AMAZON_SECRET_KEY"]

  class Amazon

    def initialize
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
        ResponseGroup: "ItemAttributes,Images,Reviews,SalesRank",
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

    # Gets the Amazon response from the request
    # Input: hash of strings
    # Output: XML
    def get(item_id, affiliate_tag)
      HTTParty.get(signed_request(item_id, affiliate_tag))
    end
  end
end
