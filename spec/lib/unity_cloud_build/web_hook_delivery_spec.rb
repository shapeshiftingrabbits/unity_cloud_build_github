# frozen_string_literal: true

RSpec.describe UnityCloudBuild::WebHookDelivery do
  describe '#initialize' do
    context 'when passing a signature' do
      subject { described_class.new('my body', '12345', 'Impact event', '67890', 'sekret') }

      it 'sets the attributes correctly' do
        expect(subject.body).to eql 'my body'
        expect(subject.hook_id).to eql '12345'
        expect(subject.event).to eql 'Impact event'
        expect(subject.delivery_id).to eql '67890'
        expect(subject.signature).to eql 'sekret'
      end
    end

    context 'when not passing a signature' do
      subject { described_class.new('my body', '12345', 'Impact event', '67890') }

      it 'sets the attributes correctly' do
        expect(subject.body).to eql 'my body'
        expect(subject.hook_id).to eql '12345'
        expect(subject.event).to eql 'Impact event'
        expect(subject.delivery_id).to eql '67890'
        expect(subject.signature).to be_nil
      end
    end
  end

  describe '#json_body' do
    subject { described_class.new(body, nil, nil, nil, nil).json_body }

    context 'with a JSON parsable body' do
      let(:body) {
        '{"projectName":"MyProject","buildTargetName":"My Target Name","projectGuid":"aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee","orgForeignKey":"11111111111111","buildNumber":10,"buildStatus":"success","lastBuiltRevision":"30d852ea80c5c8e32cb36918e84f654e884e4b12"}'
      }

      it 'returns a valid Hash' do
        is_expected.to match({
          'projectName' => 'MyProject',
          'buildTargetName' => 'My Target Name',
          'projectGuid' => 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee',
          'orgForeignKey' => '11111111111111',
          'buildNumber' => 10,
          'buildStatus' => 'success',
          'lastBuiltRevision' => '30d852ea80c5c8e32cb36918e84f654e884e4b12'
        })
      end
    end

    context 'with a JSON un-parsable body' do
      let(:body) { 'invalid' }

      it 'returns an empty Hash' do
        is_expected.to be_a Hash
        is_expected.to be_empty
      end
    end
  end
end
