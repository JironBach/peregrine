# Handles HTTP Requests to Amazon Product Advertising API

# More info: http://docs.aws.amazon.com/AWSECommerceService/latest/DG/rest-signature.html

module Amazon
  require 'HTTParty'
  require 'cgi'
  require "addressable/uri"

  ACCESS_KEY = ENV["AMAZON_ACCESS_KEY"]
  SECRET_KEY = ENV["AMAZON_SECRET_KEY"]

  Class Amazon

    # Calls the Amazon Product Advertising API
    # Input: string
    # Output: XML (?)
    def get_request(request)
      HTTParty.get(request)
    end

    private
    # Calculates an RFC 2104-compliant HMAC with the SHA256 hash algorithm using the SECRET_KEY
    # Input: string
    # Output: string
    def generate_signature(unsigned_string)
      Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::SHA256.new, SECRET_KEY, unsigned_string)).gsub('+', '%2B').gsub('+', '%3d')
    end

    # Creates the final, signed HTTP request
    # Input: string
    # Output: string
    def signed_request(query)
      unsigned_request = ['GET', 'webservices.amazon.com', '/onca/xml', query].join("\n")
      "http://webservices.amazon.com/onca/xml?" + query + "&Signature=#{generate_signature(unsigned_request)}"
    end
  end
end
