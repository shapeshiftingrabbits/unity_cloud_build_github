# frozen_string_literal: true

RSpec.describe UnityCloudBuild::BuildStatusRequest do
  describe '#initialize' do
    context 'when passing a build_target_id' do
      subject { described_class.new('org_1', 'project_2', 'build_3', 'target_4') }

      it 'sets the attributes correctly' do
        expect(subject.organization_id).to eql 'org_1'
        expect(subject.project_id).to eql 'project_2'
        expect(subject.build_number).to eql 'build_3'
        expect(subject.build_target_id).to eql 'target_4'
        expect(subject.response_body).to be_nil
      end
    end

    context 'when not passing a build_target_id' do
      subject { described_class.new('org_1', 'project_2', 'build_3') }

      it 'sets the attributes correctly' do
        expect(subject.organization_id).to eql 'org_1'
        expect(subject.project_id).to eql 'project_2'
        expect(subject.build_number).to eql 'build_3'
        expect(subject.build_target_id).to eql '_all'
        expect(subject.response_body).to be_nil
      end
    end
  end

  describe '#request_url' do
    subject { described_class.new('org_1', 'project_2', 'build_3', 'target_4') }

    it 'returns the correct API URL' do
      expect(subject.request_url).to eql 'https://build-api.cloud.unity3d.com/api/v1/orgs/org_1/projects/project_2/buildtargets/target_4/builds/build_3'
    end
  end

  skip '#call!' do
  end

  skip '#json_response_body' do
  end
end
