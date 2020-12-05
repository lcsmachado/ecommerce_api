module Admin::V1
  class LicensesController < ApiController
    def index
      @licenses = License.all
    end
  end
end
