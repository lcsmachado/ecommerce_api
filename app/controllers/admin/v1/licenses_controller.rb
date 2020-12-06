module Admin::V1
  class LicensesController < ApiController
    before_action :load_license, only: %i[show update destroy]

    def index
      @loading_service = Admin::ModelLoadingService.new(License.all, searchable_params)
      @loading_service.call
    end

    def create
      @license = License.new
      @license.attributes = license_params
      save_license!
    end

    def show; end
    
    private 

    def load_license
      @license = License.find(params[:id])      
    end
    
    def searchable_params
      params.permit({ search: :name }, { order: {} }, :page, :length)
    end

    def license_params
      return {} unless params.has_key?(:license)

      permitted_params = params.require(:license).permit(:id, :key, :platform, :status, :game_id)
    end

    def save_license!
      @license.save!
      render :show
    rescue StandardError
      render_error(fields: @license.errors.messages)
    end
  end
end
