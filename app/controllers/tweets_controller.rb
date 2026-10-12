class TweetsController < ApplicationController
  before_action :set_tweet, only: %i[show edit update destroy]

  # GET /tweets
  def index
    @tweets = Tweet.all.order(created_at: :desc)
  end

  # GET /tweets/1
  def show; end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
  end

  # GET /tweets/1/edit
  def edit; end

  # POST /tweets
  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.user = current_user
    @tweet.replied_to_id = params[:tweet][:replied_to_id]
    if @tweet.save
      reply = @tweet.replied_to_id.present?
      redirect_to reply ? tweet_url(@tweet.replied_to_id) : tweets_url,
                  notice: reply ? "Your reply was posted." : "Your tweet was posted."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tweets/1
  def update
    if @tweet.update(tweet_params)
      redirect_to @tweet, notice: "Tweet updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tweets/1
  def destroy
    parent = @tweet.replied_to
    removed_ids = tweet_tree_ids(@tweet)
    notice = parent ? "Reply deleted." : "Tweet deleted."
    @tweet.destroy

    if params[:redirect].present?
      redirect_to parent ? tweet_url(parent) : tweets_url, notice: notice, status: :see_other
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: destroy_streams(removed_ids, parent, notice) }
        format.html { redirect_to tweets_url, notice:, status: :see_other }
      end
    end
  end

  private

  # The tweet plus all its replies, recursively (they go away with it via dependent: :destroy).
  def tweet_tree_ids(tweet)
    [tweet.id] + tweet.replies.flat_map { |reply| tweet_tree_ids(reply) }
  end

  # Targets that aren't on the current page are ignored by Turbo.
  def destroy_streams(removed_ids, parent, notice)
    streams = [
      turbo_stream.remove_all(removed_ids.map { |id| "[data-tweet='#{id}']" }.join(", ")),
      turbo_stream.update(helpers.dom_id(current_user, :tweets_count), current_user.tweets.count),
      turbo_stream.update(helpers.dom_id(current_user, :likes_count), current_user.likes.count),
      turbo_stream.append("toasts", partial: "shared/toast",
                                    locals: { message: notice, type: :notice })
    ]
    if parent
      counter = "[data-replies-count='#{parent.id}']"
      # Turbo Stream helper, not ActiveRecord#update_all.
      streams << turbo_stream.update_all(counter, parent.reload.replies_count) # rubocop:disable Rails/SkipsModelValidations
    end
    streams
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def tweet_params
    params.require(:tweet).permit(:body, :replies_count, :likes_count, :replied_to_id)
  end
end
