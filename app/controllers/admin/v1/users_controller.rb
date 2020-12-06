module Admin::V1
  class UsersController < ApiController
    before_action :load_users, only: %i[update destroy]

    def index
      @loading_service = Admin::ModelLoadingService.new(User.all, searchable_params)
      @loading_service.call
    end

    def create
      @user = User.new
      @user.attributes = user_params
      save_user!
    end

    def update
      @user.attributes = user_params
      save_user!
    end

    def destroy
      @user.destroy!
    rescue StandardError
      render_error(fields: @user.errors.messages)
    end

    private

    def load_users
      @user = User.find(params[:id])
    end

    def searchable_params
      params.permit({ search: :name }, { order: {} }, :page, :length)
    end

    def user_params
      return {} unless params.has_key?(:user)

      params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile)
    end

    def save_user!
      @user.save!
      render :show
    rescue StandardError
      render_error(fields: @user.errors.messages)
    end
  end
end
