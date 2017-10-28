# frozen_string_literal: true

require 'sinatra/base'
require_relative 'lib'

class UnityCloudBuildGithub < Sinatra::Application
  post '/unity-cloud-build' do
    logger.info '== Received request =='
    logger.info 'Analysing parameters'

    @web_hook_delivery = UnityCloudBuild::WebHookDelivery.new(
      request.body.read,
      request.get_header('HTTP_X_UNITYCLOUDBUILD_HOOKID'),
      request.get_header('HTTP_X_UNITYCLOUDBUILD_EVENT'),
      request.get_header('HTTP_X_UNITYCLOUDBUILD_DELIVERYID'),
      request.get_header('HTTP_X_UNITYCLOUDBUILD_SIGNATURE')
    )

    logger.info "Hook ID header: #{@web_hook_delivery.hook_id}"
    logger.info "Event header: #{@web_hook_delivery.event}"
    logger.info "Delivery ID header: #{@web_hook_delivery.delivery_id}"
    logger.info "Signature header: #{@web_hook_delivery.signature}"
    logger.info "Body \n#{@web_hook_delivery.body}"

    logger.info '== Asking Unity Cloud Build which commit is related to this build event =='
    unity_cloud_build_api_url = 'https://build-api.cloud.unity3d.com/api/v1'

    url = File.join(
      unity_cloud_build_api_url,
      'orgs',
      "#{@web_hook_delivery.json_body['orgForeignKey']}",
      'projects',
      "#{@web_hook_delivery.json_body['projectGuid']}",
      'buildtargets',
      '_all',
      'builds',
      "#{@web_hook_delivery.json_body['buildNumber']}"
    )

    logger.info "Sending request to #{url}..."
    command = "curl -X GET -H \"Content-Type: application/json\" -H \"Authorization: Basic #{ENV['UNITY_CLOUD_BUILD_AUTH_TOKEN']}\" #{url}"
    logger.info command

    response = `#{command}`
    logger.info 'Received response'
    json = JSON.parse(response)

    logger.info json

    if json['lastBuiltRevision']
      logger.info "Commit that triggered build is #{json['lastBuiltRevision']}"
    else
      logger.info "ID of commit that triggered the build was not returned in response. Aborting."
    end
  end
end
