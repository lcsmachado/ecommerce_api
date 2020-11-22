require 'rails_helper'

RSpec.describe 'Admin::V1::Users as :client' do
  let(:user) { create(:user, profile: :client) }

  context 'GET /admin/v1/users' do
    let(:url) { '/admin/v1/users' }
    let(:users) { create_list(:user, 5) }
    before(:each) { get url, headers: auth_header(user) }
    include_examples 'forbidden access'
  end

  context 'POST /admin/v1/users' do
    let(:url) { '/admin/v1/users' }
    before(:each) { post url, headers: auth_header(user) }
    include_examples 'forbidden access'
  end

  context 'PATCH /admin/v1/users/:id' do
    let(:url) { "/admin/v1/users/#{user.id}" }
    before(:each) { patch url, headers: auth_header(user) }
    include_examples 'forbidden access'
  end

  context 'DELETE /admin/v1/users/:id' do
    let(:url) { "/admin/v1/users/#{user.id}" }
    before(:each) { delete url, headers: auth_header(user) }
    include_examples 'forbidden access'
  end
end
