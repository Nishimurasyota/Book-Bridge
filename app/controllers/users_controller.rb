class UsersController < ApplicationController
  def index
    @users = User.all
    @users = User.page(params[:page]).per(8)
    @search = Book.ransack(params[:q])
    @results = @search.result.order("name").page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
    @reviews = Review.where(user_id: @user.id).page(params[:page]).per(5)
    # @reviewsでuserのidを持つレビューを定義する
    # 定義されたレビューを.page(params[:page]).per(5)でページング機能を使い表示する
    @search = Book.ransack(params[:q])
    @results = @search.result.order("name").page(params[:page]).per(10)
  end

  def edit
    @user = User.find(params[:id])
    if @user.id == current_user.id
    else redirect_to edit_user_path(current_user.id)
      # URLを直接書いた場合でも入れない様に記述
    end
    @search = Book.ransack(params[:q])
    @results = @search.result.order("name").page(params[:page]).per(10)
  end

  def update
    @user = User.find(params[:id])
    @search = Book.ransack(params[:q])
    @results = @search.result.order("name").page(params[:page]).per(10)
    if @user.update(user_params)
        redirect_to user_path(@user.id)
    else
        @current_user = User.find(current_user.id)
        render "edit"
    end
  end

  def favorite
    @user = User.find(params[:id])
    @favorites = Favorite.where(user_id: @user.id).page(params[:page]).per(10)
    # @favoritesで@userのidを持つfavoritesを定義する
    # 定義されたを@favoritesを.page(params[:page]).per(5)でページング機能を使い表示する
    @search = Book.ransack(params[:q])
    @results = @search.result.order("name").page(params[:page]).per(10)
  end

  private
  def user_params
    params.require(:user).permit(:name, :introduction, :image, :email)
  end

end
