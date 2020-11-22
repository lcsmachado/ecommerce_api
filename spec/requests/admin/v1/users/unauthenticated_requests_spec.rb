require 'rails_helper'

RSpec.describe 'Admin::V1::Users without authentication' do
  let(:user) { create(:user, profile: :client) }

  context 'GET /admin/v1/users' do
    let(:url) { '/admin/v1/users' }
    let(:users) { create_list(:user, 5) }
    before(:each) { get url }
    include_examples 'unauthenticated access'
  end

  context 'POST /admin/v1/users' do
    let(:url) { '/admin/v1/users' }
    before(:each) { post url }
    include_examples 'unauthenticated access'
  end

  context 'PATCH /admin/v1/users/:id' do
    let(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" }
    before(:each) { patch url }
    include_examples 'unauthenticated access'
  end

  context 'DELETE /admin/v1/users/:id' do
    let(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" }
    before(:each) { delete url }
    include_examples 'unauthenticated access'
  end
end
