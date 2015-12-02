module Expressly
  class Api
    
    def initialize(apikey, endpoint = 'https://prod.expresslyapp.com/api')
      partitionedApiKey = apikey.partition(':')
      @merchantUuid = partitionedApiKey[0]
      @secretKey = partitionedApiKey[2]
      @endpoint = endpoint
    end

    def ping?
      response = execute('/v1/merchant/ping', 'GET')
      return JSON.parse(response.body)['success']
    end

    def install(baseUrl)
      apiKey = Base64.strict_encode64("#{@merchantUuid}:#{@secretKey}")
      response = execute(
        '/v2/plugin/merchant', 
        'POST', 
        "{\"apiBaseUrl\":\"#{baseUrl}\", \"apiKey\":\"#{apiKey}\"}")
    end

    def uninstall?
      response = execute(
        "/v2/plugin/merchant/#{@merchantUuid}", 
        'DELETE')
      return JSON.parse(response.body)['success']
    end

    def fetch_migration_confirmation_html(campaign_customer_uuid)
      response = execute(
        "/v2/migration/#{campaign_customer_uuid}", 
        'GET')
      return response.body
    end

    def fetch_customer_data(campaign_customer_uuid)
      response = execute(
        "/v2/migration/#{campaign_customer_uuid}/user", 
        'GET')
      return CustomerImport.from_json(JSON.parse(response.body))
    end

    def confirm_migration_success?(campaign_customer_uuid)
      response = execute(
        "/v2/migration/#{campaign_customer_uuid}/success", 
        'POST')
      return JSON.parse(response.body)['success']
    end

    def execute(methodUri, httpVerb, body = nil)
      uri = URI.parse("#{@endpoint}#{methodUri}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = @endpoint.start_with?('https')
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request =
        if httpVerb == 'GET' then Net::HTTP::Get.new(uri.request_uri)
        elsif httpVerb == 'POST' then Net::HTTP::Post.new(uri.request_uri)
        elsif httpVerb == 'DELETE' then Net::HTTP::Delete.new(uri.request_uri)
        else raise "unexpected http verb [#{httpVerb}]"
        end

      request.basic_auth(@merchantUuid, @secretKey)
      if body != nil then
        request["Content-Type"] = 'application/json'
        request.body = body
      end

      response = http.request(request)

      if response.code.to_i >= 300
        handle_error(response)
      end

      return response
    end

    def handle_error(response)
      is_json = response.content_type == "application/json"
      body = is_json ? JSON.parse(response.body) : response.body

      raise (if is_json && !body['id'].nil? then
        ExpresslyError.new(body) else
        HttpError.new(response)  end)
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