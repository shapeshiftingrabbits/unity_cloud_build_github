# frozen_string_literal: true

require 'json'

module UnityCloudBuild
  class BuildStatusRequest
    UNITY_CLOUD_BUILD_API_URL = 'https://build-api.cloud.unity3d.com/api/v1'

    attr_reader :organization_id, :project_id, :build_number, :build_target_id, :response_body, :command

    def initialize(organization_id, project_id, build_number, build_target_id = '_all')
      @organization_id = organization_id
      @project_id = project_id
      @build_number = build_number
      @build_target_id = build_target_id
      @command = 'curl -X GET -H "Content-Type: application/json" -H "Authorization: Basic ' \
                 "#{ENV['UNITY_CLOUD_BUILD_AUTH_TOKEN']}\" #{request_url}"
      @response = nil
    end

    def request_url
      @request_url ||= File.join(
        UNITY_CLOUD_BUILD_API_URL,
        'orgs', organization_id.to_s,
        'projects', project_id.to_s,
        'buildtargets', build_target_id.to_s,
        'builds', build_number.to_s
      )
    end

    def call!
      @response_body = `#{command}`
    end

    def json_response_body
      @json_response_body ||= JSON.parse(response_body)
    rescue JSON::ParserError
      @json_response_body = {}
    end
  end
end
