require 'sinatra'
require_relative 'lib/unity_cloud_build/web_hook_delivery'

post '/unity-cloud-build' do
  logger.info "== Received request =="
  logger.info "Analysing parameters"

  @web_hook_delivery = UnityCloudBuild::WebHookDelivery.new(
    request.body.read,
    request.get_header("HTTP_X_UNITYCLOUDBUILD_HOOKID"),
    request.get_header("HTTP_X_UNITYCLOUDBUILD_EVENT"),
    request.get_header("HTTP_X_UNITYCLOUDBUILD_DELIVERYID"),
    request.get_header("HTTP_X_UNITYCLOUDBUILD_SIGNATURE")
  )

  logger.info "Hook ID header: #{@web_hook_delivery.hook_id}"
  logger.info "Event header: #{@web_hook_delivery.event}"
  logger.info "Delivery ID header: #{@web_hook_delivery.delivery_id}"
  logger.info "Signature header: #{@web_hook_delivery.signature}"
  logger.info "Body \n#{@web_hook_delivery.body}"
end
