# Be sure to restart your server when you modify this file.

# Application-wide content security policy. If user content ever slips past ERB escaping,
# the browser still refuses to run any script that isn't ours.
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.base_uri    :self
    policy.object_src  :none
    policy.frame_ancestors :none
    policy.font_src    :self, :data, "https://fonts.gstatic.com"
    policy.img_src     :self, :data, :blob
    policy.script_src  :self
    # Turbo's progress bar injects an un-nonced <style>; styles can't run code.
    policy.style_src   :self, :unsafe_inline, "https://fonts.googleapis.com"
    # The GitHub sign-in form redirects there, and browsers check form-action on redirects.
    policy.form_action :self, "https://github.com"
    # Dev tools (web-console, rails_live_reload) talk to the server over a websocket.
    policy.connect_src :self, *(Rails.env.development? ? %w[ws://localhost:* ws://127.0.0.1:*] : [])
  end

  # Nonces for the importmap and the inline module script it renders. Stable per session so
  # Turbo sees the same <head> scripts on every visit and doesn't re-run them.
  config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  config.content_security_policy_nonce_directives = %w[script-src]
end
