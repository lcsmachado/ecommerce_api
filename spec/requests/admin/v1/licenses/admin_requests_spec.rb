require 'rails_helper'

RSpec.describe 'Admin::V1:Licenses as :admin', type: :request do
  let(:user) { create(:user) }
  let(:game) { create(:game) }

  context 'GET /licenses' do
    let(:url) { '/admin/v1/licenses' }
    let(:licenses) { create_list(:license, 10) }

    it 'returns all licenses' do
      get url, headers: auth_header(user)
      expect(body_json['licenses']).to contain_exactly(*licenses.as_json(only: %i[id key]))
    end

  end
  
  context 'POST /licenses' do
    
  end

  context 'GET /licenses/:id' do
    
  end

  context 'PATCH /licenses/:id' do
    
  end

  context 'DELETE /licenses/:id' do
    
  end
end