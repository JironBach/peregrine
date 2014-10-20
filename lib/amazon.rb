# Handles HTTP Requests to Amazon Product Advertising API

# More info: http://docs.aws.amazon.com/AWSECommerceService/latest/DG/rest-signature.html

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
    # Calls the Amazon Product Advertising API
    # Input: string
    # Output: XML (?)
    def get_request(query_params)
      HTTParty.get(signed_request(unsigned_query(query_params)))
    end

    # Takes query parameters hash and returns query with ordered params.
    # Input: hash of strings
    # Output: string
    def unsigned_query(query_params)
      uri = Addressable::URI.new
      uri.query_values = {
        AWSAccessKeyId: ACCESS_KEY.to_s,
        AssociateTag: query_params[:associate_tag],
        ItemId: query_params[:item_id],
        Version: Time.now.getutc.strftime("%F"),
        Timestamp: Time.now.getutc.strftime("%FT%TZ"),
        Operation: query_params[:operation],
        ResponseGroup: query_params[:response_group],
        Service: "AWSECommerceService"
      }

      uri.query.gsub(':', '%3A').gsub(',', '%2C') # escape special chars
    end

    # Calculates an RFC 2104-compliant HMAC with the SHA256 hash algorithm using the SECRET_KEY
    # Input: string
    # Output: string
    def signature(unsigned_request)
      Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::SHA256.new, SECRET_KEY, unsigned_request)).gsub('+', '%2B').gsub('+', '%3d')
    end

    # Creates the final, signed HTTP request
    # Input: string
    # Output: string
    def signed_request(unsigned_query)
      unsigned_request = ['GET', 'webservices.amazon.com', '/onca/xml', unsigned_query].join("\n")
      signed_request = "http://webservices.amazon.com/onca/xml?" + unsigned_query + "&Signature=#{signature(unsigned_request)}"
    end
  end

  a = Amazon.new

  query_params = {
    associate_tag: "georbani-20",
    item_id: "B00I9GYG8O",
    operation: "ItemLookup",
    responsne_group: "ItemAttributes,Images,Reviews,SalesRank"
  }
  binding.pry
  a.get_request(query_params)
end

