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

    def query
      uri = Addressable::URI.new

      uri.query_values = {
        AWSAccessKeyId: ACCESS_KEY.to_s,
        AssociateTag: "georbani-20",
        ItemId: "B00I9GYG8O",
        Version: Time.now.getutc.strftime("%F"),
        Timestamp: Time.now.getutc.strftime("%FT%TZ"),
        Operation: "ItemLookup",
        ResponseGroup: "ItemAttributes,Images,Reviews,SalesRank",
        Service: "AWSECommerceService"
      }

      uri.query.gsub(':', '%3A').gsub(',', '%2C')
    end

    def unsigned_request(query)
      ['GET', 'webservices.amazon.com', '/onca/xml', query].join("\n")
    end

    def generate_signature(unsigned_string)
      Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::SHA256.new, SECRET_KEY, unsigned_string)).gsub('+', '%2B').gsub('+', '%3d')
    end

    def request
      "http://webservices.amazon.com/onca/xml?" + query + "&Signature=#{generate_signature(unsigned_request(query))}"
    end

    def response
      HTTParty.get(request)
    end
  end

  a = Amazon.new
  puts a.response
end
