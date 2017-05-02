require "iamport/version"
require 'faraday'
require 'faraday_middleware'

module Iamport
  IAMPORT_HOST = "https://api.iamport.kr".freeze

  class Config
    attr_accessor :api_key
    attr_accessor :api_secret
  end

  class << self
    def configure
      yield(config) if block_given?
    end

    def config
      @config ||= Config.new
    end

    # Get Token
    # https://api.iamport.kr/#!/authenticate/getToken
    def token
      result = conn.post do |req|
        req.url '/users/getToken'
        req.body = {
            imp_key: config.api_key,
            imp_secret: config.api_secret
        }
      end
      result.body["response"]["access_token"]
    end

    # Get payment information using imp_uid
    # https://api.iamport.kr/#!/payments/getPaymentByImpUid
    def payment(imp_uid)
      uri = "payments/#{imp_uid}"

      pay_get(uri)
    end

    # Search payment information using status.
    # default items per page: 20
    # https://api.iamport.kr/#!/payments/getPaymentsByStatus
    def payments(options = {})
      status = options[:status] || "all"
      page = options[:page] || 1

      uri = "payments/status/#{status}?page=#{page}"

      pay_get(uri)
    end

    # Find payment information using merchant uid
    # https://api.iamport.kr/#!/payments/getPaymentByMerchantUid
    def find(merchant_uid)
      uri = "payments/find/#{merchant_uid}"

      pay_get(uri)
    end

    # Canceled payments
    # https://api.iamport.kr/#!/payments/cancelPayment
    def cancel(body)
      uri = "payments/cancel"

      pay_post(uri, body)
    end

    private

    # GET
    def pay_get(uri, payload = {})
      result = conn.get do |req|
        req.url uri
        req.headers['Authorization'] = token
        req.body = payload
      end
      result.body
    end

    # POST
    def pay_post(uri, payload = {})
      result = conn.post do |req|
        req.url uri
        req.headers['Authorization'] = token
        req.body = payload
      end
      result.body
    end

    def conn
      Faraday.new(url: IAMPORT_HOST) do |conn|
        conn.request :json
        conn.response :json
        conn.adapter Faraday.default_adapter
      end
    end
  end
end
