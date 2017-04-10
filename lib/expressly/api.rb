module Expressly
  class Api
    
    def initialize(apikey, endpoint = 'https://prod.expresslyapp.com/api')
      partitioned_api_key = apikey.partition(':')
      @merchant_uuid = partitioned_api_key[0]
      @secret_key = partitioned_api_key[2]
      @endpoint = endpoint
    end

    def ping?
      response = execute('/v1/merchant/ping', 'GET')
      JSON.parse(response.body)['success']
    end

    def install(base_url)
      api_key = Base64.strict_encode64("#{@merchant_uuid}:#{@secret_key}")
      execute(
        '/v2/plugin/merchant', 
        'POST', 
        "{\"apiBaseUrl\":\"#{base_url}\", \"apiKey\":\"#{api_key}\"}")
    end

    def uninstall?
      response = execute(
        "/v2/plugin/merchant/#{@merchant_uuid}", 
        'DELETE')
      JSON.parse(response.body)['success']
    end

    def fetch_migration_confirmation_html(campaign_customer_uuid)
      response = execute(
        "/v2/migration/#{campaign_customer_uuid}", 
        'GET')
      response.body
    end

    def fetch_customer_data(campaign_customer_uuid)
      response = execute(
        "/v2/migration/#{campaign_customer_uuid}/user", 
        'GET')
      CustomerImport.from_json(JSON.parse(response.body))
    end

    def confirm_migration_success?(campaign_customer_uuid)
      response = execute(
        "/v2/migration/#{campaign_customer_uuid}/success", 
        'POST')
      JSON.parse(response.body)['success']
    end

    def execute(method_uri, http_verb, body = nil, limit = 4)
      raise 'too many HTTP redirects' if limit == 0
      puts method_uri

      uri = URI.parse("#{@endpoint}#{method_uri}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = @endpoint.start_with?('https')
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request =
        if http_verb == 'GET' then Net::HTTP::Get.new(uri.request_uri)
        elsif http_verb == 'POST' then Net::HTTP::Post.new(uri.request_uri)
        elsif http_verb == 'DELETE' then Net::HTTP::Delete.new(uri.request_uri)
        else raise "unexpected http verb [#{http_verb}]"
        end

      request.basic_auth(@merchant_uuid, @secret_key)
      if body != nil then
        request["Content-Type"] = 'application/json'
        request.body = body
      end

      response = http.request(request)

      case response
        when Net::HTTPSuccess then
          response
        when Net::HTTPRedirection then
          location = response['location']
          execute(location, http_verb, body,limit - 1)
        else
          handle_error(response)
      end
    end

    def handle_error(response)
      is_json = response.content_type == "application/json"
      body = is_json ? JSON.parse(response.body) : response.body

      raise (if is_json && !body['id'].nil? then ExpresslyError.new(body) else HttpError.new(response) end)
    end

    private :execute, :handle_error
  end

  class HttpError < StandardError
    attr_accessor   :code, :body
    def initialize(response)
      super(response.message)
      @code = response.code
      @body = response.body
      self.freeze
    end

    private :initialize

  end

  class ExpresslyError < StandardError
    attr_accessor   :id, :code, :description, :causes, :actions
    def initialize(response)
      super(response['message'])
      @id = response['id']
      @code = response['code']
      @description = response['description']
      @causes = response['causes']
      @actions = response['actions']
      self.freeze
    end
  end

  private :initialize

end

require "net/http"
require "net/https"
require "uri"
require 'json'
require 'base64'