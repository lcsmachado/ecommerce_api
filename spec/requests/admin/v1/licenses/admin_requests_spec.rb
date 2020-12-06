require 'rails_helper'

RSpec.describe 'Admin::V1:Licenses as :admin', type: :request do
  let(:user) { create(:user) }
  let(:game) { create(:game) }

  context 'GET /licenses' do
    let(:url) { '/admin/v1/licenses' }
    let!(:licenses) { create_list(:license, 10) }

    context 'without any params' do

      it 'returns 10 licenses' do
        get url, headers: auth_header(user)
        expect(body_json['licenses'].count).to eq 10
      end

      it 'returns first 10 categories' do
        get url, headers: auth_header(user)
        expected_licenses = licenses[0..9].as_json(only: %i[id key])
        expect(body_json['licenses']).to contain_exactly(*expected_licenses)
      end

      it 'returns success status' do
        get url, headers: auth_header(user)
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'pagination meta attributes', { page: 1, length: 10, total: 10, total_pages: 1 } do
        before { get url, headers: auth_header(user) }
      end
    end

    context 'with pagination params' do
      let(:page) { 2 }
      let(:length) { 5 }

      let(:pagination_params) { { page: page, length: length } }

      it 'returns record sized by :length' do
        get url, headers: auth_header(user), params: pagination_params
        expect(body_json['licenses'].count).to eq length
      end

      it 'returns licenses limited by pagination' do
        get url, headers: auth_header(user), params: pagination_params
        expected_licenses = licenses[5..9].as_json(only: %i[id key])
        expect(body_json['licenses']).to contain_exactly(*expected_licenses)
      end

      it 'returns success status' do
        get url, headers: auth_header(user), params: pagination_params
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'pagination meta attributes', { page: 2, length: 5, total: 10, total_pages: 2 } do
        before { get url, headers: auth_header(user), params: pagination_params }
      end
    end
  end
  
  context 'POST /licenses' do
    let(:url) { '/admin/v1/licenses' }

    context 'with valid params' do
      let(:license_params) { { license: attributes_for(:license, game_id: game.id) }.to_json }

      it 'adds a new license' do
        expect do
          post url, headers: auth_header(user), params: license_params
        end.to change(License, :count).by(1)
      end

      it 'returns last added license' do
        post url, headers: auth_header(user), params: license_params
        expected_license = License.last.as_json(only: %i[id key])
        expect(body_json['license']).to contain_exactly(*expected_license)
      end

      it 'returns success status' do
        post url, headers: auth_header(user), params: license_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:license_invalid_params) do
        { license: attributes_for(:license, key: '') }.to_json
      end
      
      it 'does not add a new license' do
        expect do
          post url, headers: auth_header(user), params: license_invalid_params
        end.to_not change(License, :count)
      end

      it 'returns error messages' do
        post url, headers: auth_header(user), params: license_invalid_params
        expect(body_json['errors']['fields']).to have_key('key')
      end

      it 'returns unprocessable_entity status' do
        post url, headers: auth_header(user), params: license_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
    
  end

  context 'GET /licenses/:id' do
    let!(:license) { create(:license) }
    let(:url) { "/admin/v1/licenses/#{license.id}" }

    it 'returns requested license' do
      get url, headers: auth_header(user)
      expected_license = license.as_json(only: %i[id key])
      expect(body_json['license']).to contain_exactly(*expected_license) 
    end

    it 'return success status' do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end

  context 'PATCH /licenses/:id' do
    let!(:license) { create(:license) }
    let(:url) { "/admin/v1/licenses/#{license.id}" }

    context 'with valid license params' do
      let(:new_game) { create(:game) }
      let(:license_params) do
        { license: attributes_for(:license, game_id: new_game.id) }.to_json
      end

      it 'updates license' do
        patch url, headers: auth_header(user), params: license_params
        license.reload
        expect(license.game_id).to eq new_game.id
      end

      it 'returns updated license' do
        patch url, headers: auth_header(user), params: license_params
        license.reload
        expected_license = license.as_json(only: %i[id key])
        expect(body_json['license']).to contain_exactly(*expected_license)
      end

      it 'returns success status' do
        patch url, headers: auth_header(user), params: license_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid license params' do
      let(:license_invalid_params) do
        { license: attributes_for(:license, key: '') }.to_json
      end
      
      it 'does not update license' do
        old_key = license.key
        patch url, headers: auth_header(user), params: license_invalid_params
        license.reload
        expect(license.key).to eq old_key
      end

      it 'returns error messages' do
        patch url, headers: auth_header(user), params: license_invalid_params
        expect(body_json['errors']['fields']).to have_key('key')
      end

      it 'returns unprocessable entity status' do
        patch url, headers: auth_header(user), params: license_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'DELETE /licenses/:id' do
    let!(:license) { create(:license) }
    let(:url) { "/admin/v1/licenses/#{license.id}" }

    it 'removes license' do
      expect do  
        delete url, headers: auth_header(user)
      end.to change(License, :count).by(-1)
    end

    it 'returns success status' do
      delete url, headers: auth_header(user)
      expect(response).to have_http_status(:no_content)
    end

    it 'does not return any body content' do
      delete url, headers: auth_header(user)
      expect(body_json).to_not be_present
    end
  end
end