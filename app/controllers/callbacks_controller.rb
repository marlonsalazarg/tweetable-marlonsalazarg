class CallbacksController < Devise::OmniauthCallbacksController
  def github
    auth_hash = request.env["omniauth.auth"]
    @user = User.from_omniauth(auth_hash)

    # Not saved when GitHub gives no email or the email already belongs to an account here
    # (accounts are never linked by email alone).
    if @user.persisted?
      sign_in_and_redirect @user
    else
      redirect_to new_user_registration_url, status: :see_other,
                                             alert: "Couldn't sign in with GitHub: " \
                                                    "#{@user.errors.full_messages.to_sentence}."
    end
  end
end
