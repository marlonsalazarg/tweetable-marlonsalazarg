class LikesController < ApplicationController
  # POST /likes?tweet=:tweet_id
  def create
    @tweet = Tweet.find(params[:tweet])
    create_like
    respond_with_like_button
  end

  # DELETE /likes/:tweet_id (the tweet id, not a Like id)
  def destroy
    @tweet = Tweet.find(params[:id])
    Like.find_by(user: current_user, tweet: @tweet)&.destroy
    respond_with_like_button
  end

  private

  # A double click or concurrent request hits the unique index; the like already exists.
  def create_like
    Like.create(user: current_user, tweet: @tweet)
  rescue ActiveRecord::RecordNotUnique
    nil
  end

  def respond_with_like_button
    @tweet.reload
    respond_to do |format|
      format.turbo_stream { render turbo_stream: like_streams }
      format.html { redirect_back fallback_location: tweets_path, status: :see_other }
    end
  end

  # The same tweet can be on screen more than once (profile Tweets + Likes tabs), so update
  # every copy of the button instead of a single id. The profile targets only exist when the
  # current user is looking at their own profile; Turbo ignores missing targets.
  def like_streams
    [
      turbo_stream.replace_all("[data-like-button='#{@tweet.id}']",
                               partial: "likes/button", locals: { tweet: @tweet }),
      turbo_stream.update(helpers.dom_id(current_user, :likes_count), current_user.likes.count),
      turbo_stream.update(helpers.dom_id(current_user, :liked_tweets),
                          partial: "users/liked_tweets", locals: { user: current_user })
    ]
  end
end
