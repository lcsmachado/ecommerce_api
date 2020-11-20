require 'rails_helper'

RSpec.describe 'Admin::V1::Coupons without authentication', type: :request do
  let(:user) { create(:user, profile: :client) }

  context 'GET /admin/v1/coupons' do
    let(:url) { '/admin/v1/coupons' }
    let(:coupons) { create_list(:coupon, 5) }
    before(:each) { get url }
    include_examples 'unauthenticated access'
  end

  context 'POST /admin/v1/coupons' do
    let(:url) { '/admin/v1/coupons' }
    before(:each) { post url }
    include_examples 'unauthenticated access'
  end

  context 'PATCH /admin/v1/coupons/:id' do
    let(:coupon) { create(:coupon) }
    let(:url) { "/admin/v1/coupons/#{coupon.id}" }
    before(:each) { patch url }
    include_examples 'unauthenticated access'
  end

  context 'DELETE /admin/v1/coupons/:id' do
    let(:coupon) { create(:coupon) }
    let(:url) { "/admin/v1/coupons/#{coupon.id}" }
    before(:each) { delete url }
    include_examples 'unauthenticated access'
  end
end
