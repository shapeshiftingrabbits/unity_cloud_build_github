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
  end
end
