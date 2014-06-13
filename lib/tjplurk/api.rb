require 'oauth'
require 'json'

module Tjplurk
  class API
    attr_reader :consumer, :request_token, :access_token

    def initialize(consumer_key = nil, consumer_secret = nil, token_key = nil, token_secret = nil)
      if consumer_key.nil? || consumer_secret.nil?
        raise 'Consumer key & secret are not found.' unless File.exist? TJPLURK_FILE
        consumer_key, consumer_secret, token_key, token_secret = File.readlines(TJPLURK_FILE).map(&:strip!).delete_if(&:empty?)
      end
      @consumer = OAuth::Consumer.new(consumer_key, consumer_secret, Tjplurk::OAUTH_OPTIONS)
      @access_token = OAuth::AccessToken.new(@consumer, token_key, token_secret) if token_key && token_secret
    end

    def request_token
      @request_token ||= @consumer.get_request_token
    end

    def request path, body = '', headers = {}
      JSON.parse(@access_token.post(path, body, headers).body)
    end
  end
end