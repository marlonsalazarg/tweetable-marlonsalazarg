class TweetsController < ApplicationController
  before_action :set_tweet, only: %i[show edit update destroy]
  before_action :authorize_edit!, only: %i[edit update]
  before_action :authorize_destroy!, only: :destroy

  # GET /tweets
  def index
    @tweets = Tweet.top_level.with_author.order(created_at: :desc)
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
    @tweet = current_user.tweets.new(params.require(:tweet).permit(:body, :replied_to_id))
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

    respond_to do |format|
      if params[:redirect].blank?
        format.turbo_stream { render turbo_stream: destroy_streams(removed_ids, parent, notice) }
      end
      format.html do
        redirect_to parent ? tweet_url(parent) : tweets_url, notice:, status: :see_other
      end
    end
  end

  private

  # The tweet plus all its replies, recursively (they go away with it via dependent: :destroy).
  def tweet_tree_ids(tweet)
    [tweet.id] + tweet.replies.flat_map { |reply| tweet_tree_ids(reply) }
  end

  # Targets that aren't on the current page are ignored by Turbo. When an admin deletes someone
  # else's tweet the author isn't current_user, so the author's counters are updated as well.
  def destroy_streams(removed_ids, parent, notice)
    author = @tweet.user
    streams = [
      turbo_stream.remove_all(removed_ids.map { |id| "[data-tweet='#{id}']" }.join(", ")),
      turbo_stream.update(helpers.dom_id(author, :tweets_count), author.tweets.count),
      *[author, current_user].uniq.map do |user|
        turbo_stream.update(helpers.dom_id(user, :likes_count), user.likes.count)
      end,
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

  def authorize_edit!
    deny_access unless @tweet.editable_by?(current_user)
  end

  def authorize_destroy!
    deny_access unless @tweet.deletable_by?(current_user)
  end

  def deny_access
    redirect_to tweet_url(@tweet), alert: "You can't change this tweet.", status: :see_other
  end

  # Only the body is editable; counters are caches and replied_to_id is fixed once created.
  def tweet_params
    params.require(:tweet).permit(:body)
  end
end
