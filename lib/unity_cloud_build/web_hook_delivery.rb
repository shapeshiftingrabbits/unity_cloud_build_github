# frozen_string_literal: true

require 'json'

module UnityCloudBuild
  class WebHookDelivery
    attr_reader :body, :hook_id, :event, :delivery_id, :signature

    def initialize(body, hook_id, event, delivery_id, signature = nil)
      @body = body
      @hook_id = hook_id
      @event = event
      @delivery_id = delivery_id
      @signature = signature
    end

    def json_body
      begin
        @json_body ||= JSON.parse(body)
      rescue JSON::ParserError
        @json_body = {}
      end
    end
  end
end
