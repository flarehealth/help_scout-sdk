# frozen_string_literal: true

module HelpScout
  class API
    class Client
      attr_reader :connection

      def initialize(skip_authorization: false)
        @skip_authorization = skip_authorization
        @connection = build_connection
      end

      private

      attr_reader :skip_authorization

      # TODO: Remove skip_auth
      def build_connection
        HelpScout::API::AccessToken.refresh! if HelpScout.access_token.nil? && !skip_authorization?

        Faraday.new(url: BASE_URL) do |conn|
          conn.request :json
          conn.authorization(:Bearer, HelpScout.access_token.value) unless skip_authorization?
          conn.response(:json, content_type: /\bjson$/)
          conn.adapter(Faraday.default_adapter)
        end
      end

      def skip_authorization?
        skip_authorization
      end
    end
  end
end