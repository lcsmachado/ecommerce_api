module Admin::V1
  class LicensesController < ApiController
    def index
      @loading_service = Admin::ModelLoadingService.new(License.all, searchable_params)
      @loading_service.call
    end

    private 

    def searchable_params
      params.permit({ search: :name }, { order: {} }, :page, :length)
    end
  end
end
