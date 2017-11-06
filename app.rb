# frozen_string_literal: true

require 'sinatra/base'
require_relative 'lib'

class UnityCloudBuildGithub < Sinatra::Application
  UNITY_CLOUD_BUILD_STATUS_MAPPINGS = {
    ProjectBuildQueued: {
      github_status: :pending,
      message: 'Build has been queued.'
    },
    ProjectBuildStarted: {
      github_status: :pending,
      message: 'Build has started.'
    }
    ProjectBuildRestarted: {
      github_status: :pending,
      message: 'Build was restarted.'
    }
    ProjectBuildSuccess:{
      github_status: :success,
      message: 'Build successful!'
    }
    ProjectBuildFailure: {
      github_status: :failure,
      message: 'Build failed.'
    },
    ProjectBuildCanceled: {
      github_status: :error,
      message: 'Build canceled.'
    }
  }.freeze

  post '/unity-cloud-build' do # rubocop:disable Metrics/BlockLength
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

    if @web_hook_delivery.json_body['lastBuiltRevision'].nil?
      logger.info '== Commit ID unknown =='
      logger.info '== Requesting commit ID from Unity Cloud Build =='
      build_status_request = UnityCloudBuild::BuildStatusRequest.new(
        @web_hook_delivery.json_body['orgForeignKey'],
        @web_hook_delivery.json_body['projectGuid'],
        @web_hook_delivery.json_body['buildNumber']
      )

      logger.info "Sending request to #{build_status_request.request_url}..."
      logger.info build_status_request.command

      build_status_request.call!
      logger.info 'Received response'

      logger.info build_status_request.json_response_body

      if build_status_request.json_response_body['lastBuiltRevision']
        logger.info "== Commit ID is #{build_status_request.json_response_body['lastBuiltRevision']} =="
      else
        logger.info 'Commit ID was not returned in response. Aborting.'
      end
    else
      logger.info "== Commit ID is #{@web_hook_delivery.json_body['lastBuiltRevision']} =="
    end

    github_client = Octokit::Client.new(access_token: ENV['GITHUB_AUTH_TOKEN'])
    github_client.create_status(
      "shapeshiftingrabbits/unity_cloud_build_github", # how to match unity project and org name to github? have a heroku/local config file only (not in version control)
      @web_hook_delivery.json_body['lastBuiltRevision'],
      UNITY_CLOUD_BUILD_STATUS_TO_GITHUB_STATUS[@web_hook_delivery.event.to_sym][:github_status],
      {
        context: "Unity Cloud Build - #{@web_hook_delivery.json_body['buildTargetName']}",
        target_url: File.join(
          @web_hook_delivery.json_body['links']['dashboard_url']['href'],
          @web_hook_delivery.json_body['links']['dashboard_log']['href']
        ),
        description: UNITY_CLOUD_BUILD_STATUS_TO_GITHUB_STATUS[@web_hook_delivery.event.to_sym][:message]
      }
    )
  end
end
