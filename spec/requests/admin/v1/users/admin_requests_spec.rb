require 'rails_helper'

RSpec.describe 'Admin::V1::Users as :admin', type: :request do
  let!(:user) { create(:user) }

  context 'GET /admin/v1/users' do
    let(:url) { '/admin/v1/users' }
    let(:users) { create_list(:user, 5) }

    it 'return all users' do
      users.push(user)
      get url, headers: auth_header(user)
      expect(body_json['users']).to contain_exactly(*users.as_json(only: %i[id name email profile]))
    end

    it 'return success status' do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end

  context 'POST /admin/v1/users' do
    let(:url) { '/admin/v1/users' }

    context 'with valid params' do
      let(:user_params) { { user: attributes_for(:user) }.to_json }

      it 'add a new user' do
        expect do
          post url, headers: auth_header(user), params: user_params
        end.to change(User, :count).by(1)
      end

      it 'return last added user' do
        post url, headers: auth_header(user), params: user_params
        expected_user = User.last.as_json(only: %i[id name email profile])
        expect(body_json['user']).to eq expected_user
      end

      it 'returns success status' do
        post url, headers: auth_header(user), params: user_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:user_params) { { user: attributes_for(:user, name: nil) }.to_json }

      it 'does not add a new user' do
        expect do
          post url, headers: auth_header(user), params: user_params
        end.to_not change(User, :count)
      end

      it 'returns error messages' do
        post url, headers: auth_header(user), params: user_params
        expect(body_json['errors']['fields']).to have_key('name')
      end

      it 'returns unprocessable_entity status' do
        post url, headers: auth_header(user), params: user_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'PATCH /admin/v1/users/:id' do
    let!(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" }

    context 'with valid params' do
      let(:new_name) { 'My New Name' }
      let(:user_update_params) { { user: { name: new_name } }.to_json }

      it 'updates user' do
        patch url, headers: auth_header(user), params: user_update_params
        user.reload
        expect(user.name).to eq new_name
      end

      it 'returns updates user' do
        patch url, headers: auth_header(user), params: user_update_params
        user.reload
        expected_user = user.as_json(only: %i[id name email profile])
        expect(body_json['user']).to eq expected_user
      end

      it 'returns success status' do
        patch url, headers: auth_header(user), params: user_update_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:user_update_params) do
        { user: attributes_for(:user, name: nil) }.to_json
      end

      it 'does not update user' do
        old_name = user.name
        patch url, headers: auth_header(user), params: user_update_params
        user.reload
        expect(user.name).to eq old_name
      end

      it 'returns error messages' do
        patch url, headers: auth_header(user), params: user_update_params
        expect(body_json['errors']['fields']).to have_key('name')
      end

      it 'returns unprocessable_entity status' do
        patch url, headers: auth_header(user), params: user_update_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'DELETE /admin/v1/users/:id' do
    let!(:user_delete) { create(:user) }
    let(:url) { "/admin/v1/users/#{user_delete.id}" }

    it 'deletes user' do
      expect do
        delete url, headers: auth_header(user)
      end.to change(User, :count).by(-1)
    end

    it 'returns no_content status' do
      delete url, headers: auth_header(user)
      expect(response).to have_http_status(:no_content)
    end

    it 'does not have any body content' do
      delete url, headers: auth_header(user)
      expect(body_json).to_not be_present
    end
  end
end
