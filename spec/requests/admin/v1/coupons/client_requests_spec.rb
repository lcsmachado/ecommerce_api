require 'rails_helper'

RSpec.describe 'Admin::V1::Coupons as :client', type: :request do
  let(:user) { create(:user, profile: :client) }

  context 'GET /admin/v1/coupons' do
    let(:url) { '/admin/v1/coupons' }
    let(:coupons) { create_list(:coupon, 5) }
    before(:each) { get url, headers: auth_header(user) }
    include_examples 'forbidden access'
  end
  
  context 'POST /admin/v1/coupons' do
    let(:url) { '/admin/v1/coupons' }
    before(:each) { post url, headers: auth_header(user) }
    include_examples 'forbidden access'
  end
  
  context 'PATCH /admin/v1/coupons/:id' do
    let(:coupon) { create(:coupon) }
    let(:url) { "/admin/v1/coupons/#{coupon.id}" }
    before(:each) { patch url, headers: auth_header(user) }
    include_examples 'forbidden access'
  end
  
  context 'DELETE /admin/v1/coupons/:id' do
    let(:coupon) { create(:coupon) }
    let(:url) { "/admin/v1/coupons/#{coupon.id}" }
    before(:each) { delete url, headers: auth_header(user) }
    include_examples 'forbidden access'
  end
end