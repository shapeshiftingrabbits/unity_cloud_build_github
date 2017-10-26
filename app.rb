require 'sinatra'
require_relative 'lib/unity_cloud_build/web_hook_delivery'

post '/unity-cloud-build' do
  @web_hook_delivery = UnityCloudBuild::WebHookDelivery.new(
    request.body,
    request.get_header("HTTP_X_UNITYCLOUDBUILD_HOOKID"),
    request.get_header("HTTP_X_UNITYCLOUDBUILD_EVENT"),
    request.get_header("HTTP_X_UNITYCLOUDBUILD_DELIVERYID"),
    request.get_header("HTTP_X_UNITYCLOUDBUILD_SIGNATURE")
  )
end
