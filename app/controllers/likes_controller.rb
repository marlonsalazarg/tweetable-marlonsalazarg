class LikesController < ApplicationController
  # before_action :set_like, only: %i[ show edit update destroy ]

  # # GET /likes
  # def index
  #   @likes = Like.all
  # end

  # # GET /likes/1
  # def show
  # end

  # # GET /likes/new
  # def new
  #   @like = Like.new
  # end

  # # GET /likes/1/edit
  # def edit
  # end

  # POST /likes
  def create
    @tweet = Tweet.find(params[:tweet])
    create_like
    respond_with_like_button
  end

  # PATCH/PUT /likes/1
  # def update
  #   if @like.update(like_params)
  #     redirect_to @like, notice: "Like was successfully updated."
  #   else
  #     render :edit, status: :unprocessable_entity
  #   end
  # end

  # DELETE /likes/1
  def destroy
    @tweet = Tweet.find(params[:id])
    Like.find_by(user: current_user, tweet: @tweet)&.destroy
    respond_with_like_button
  end

  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_like
  #     @like = Like.find(params[:id])
  #   end

  #   # Only allow a list of trusted parameters through.
  #   def like_params
  #     params.require(:like).permit(:user_id, :tweet_id)
  #   end

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
