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
end
