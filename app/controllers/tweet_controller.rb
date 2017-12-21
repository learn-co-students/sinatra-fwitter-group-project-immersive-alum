require 'pry'
class TweetController < ApplicationController

  get '/tweets' do
    if Helpers.is_logged_in?(session)
      @tweets = Tweet.all
      @user = User.find_by_id(session[:user_id])
      erb :'tweets/tweets'
    else
      redirect "/login"
    end
  end

  get '/tweets/new' do
    if Helpers.is_logged_in?(session)
      erb :'tweets/create_tweet'
    else
      redirect "/login"
    end
  end

  post '/tweets' do
    if params[:content] == "" || params[:content] == " "
      redirect "/failure"
    else
      @tweet = Tweet.create(content: params[:content])
      @user = User.find_by_id(session[:user_id])
      @user.tweets << @tweet
      redirect "/tweets"
    end
  end

  get '/tweets/:id' do
    if Helpers.is_logged_in?(session)
      @tweet = Tweet.find_by_id(params[:id])
      erb :'tweets/show_tweet'
    else
      redirect "/login"
    end
  end

  get '/tweets/:id/edit' do
    if Helpers.is_logged_in?(session)
      @tweet = Tweet.find_by_id(params[:id])
      if Helpers.current_user(session).tweets.include?(@tweet)
        erb :'tweets/edit_tweet'
      else
        redirect "/failure"
      end
    else
      redirect "/login"
    end
  end

  patch '/tweets/:id' do
    if params["tweet"]["content"] == ""
      redirect "/failure"
    else
      @tweet = Tweet.find_by_id(params[:id])
      @tweet.update(params[:tweet])
      @tweet.save
      redirect "/tweets/#{@tweet.id}"
    end
  end

  delete '/tweets/:id/delete' do
    @tweet = Tweet.find_by_id(params[:id])
    @tweet.delete
    redirect "/tweets"
  end


end
