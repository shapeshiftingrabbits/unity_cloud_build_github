RSpec.describe UnityCloudBuildGithub do
  include Rack::Test::Methods

  describe 'POST /unity-cloud-build' do
    context 'when receiving a Unity Cloud Build request' do
      it 'responds with a successful status' do
        post '/unity-cloud-build'

        expect(last_response.status).to eql 200
      end
    end

    context 'when receiving an invalid request' do
      pending 'rejects the request' do
        post '/unity-cloud-build'

        expect(last_response.status).to eql 400
      end
    end
  end
end
