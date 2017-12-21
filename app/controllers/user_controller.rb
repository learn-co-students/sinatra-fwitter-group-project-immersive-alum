require 'pry'
class UserController < ApplicationController

  get '/users/home' do
    @user = User.find_by_id(session[:user_id])
    if @user
      erb :'users/home'
    else
      redirect "/login"
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end


end
