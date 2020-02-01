class FavoritesController < ApplicationController
  def create
    favorite = Micropost.find(params[:micropost_id])
    current_user.favorite(favorite)
    flash[:success] = 'お気に入り登録しました。'
    redirect_back(fallback_location: root_path)
  end

  def destroy
    favorite = Micropost.find(params[:micropost_id])
    current_user.unfavorite(favorite)
    flash[:success] = 'お気に入り登録を解除しました。'
    redirect_back(fallback_location: root_path)
  end
end
