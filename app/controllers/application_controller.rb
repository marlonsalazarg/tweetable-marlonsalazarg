class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: %i[index show] # rubocop:disable Rails/LexicallyScopedActionFilter
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :liked_tweet_ids

  protected

  # Tweets the current user has liked, loaded once per request so every like button on the page
  # shares one query instead of running its own. Read lazily, so after a like is created or
  # destroyed the buttons re-rendered in the same request already see the change.
  def liked_tweet_ids
    @liked_tweet_ids ||= current_user ? current_user.likes.pluck(:tweet_id).to_set : Set.new
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username name avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username name avatar])
  end
end
