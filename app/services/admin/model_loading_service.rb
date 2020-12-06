module Admin  
  class ModelLoadingService
    attr_reader :records, :pagination

    def initialize(searchable_model, params = {})
      @searchable_model = searchable_model
      @params = params || {}
      @records = []
      @pagination = { page: @params[:page].to_i, length: @params[:length].to_i }
    end

    def call
      fix_pagination_values
      filtered = filter_by_name_or_get_all_records
      @records = filtered.order(@params[:order].to_h).paginate(@pagination[:page], @pagination[:length])
      total_pages = (filtered.count / @pagination[:length].to_f).ceil
      @pagination.merge!(total: filtered.count, total_pages: total_pages)
    end

    def fix_pagination_values
      @pagination[:page] = @searchable_model.model::DEFAULT_PAGE if @pagination[:page].zero?
      @pagination[:length] = @searchable_model.model::MAX_PER_PAGE if @pagination[:length].zero?
    end

    def filter_by_name_or_get_all_records
      return @searchable_model.all unless @searchable_model.respond_to?(:search_by_name)

      @searchable_model.search_by_name(@params.dig(:search, :name))
    end
  end
end