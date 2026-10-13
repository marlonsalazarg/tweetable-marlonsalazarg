# Throttles sign-in attempts so passwords can't be brute-forced.
#
# Counters live in this process's memory: Rails.cache is a null store in development, and the app
# has no shared cache (Redis/Memcached). With several Puma workers each one counts on its own, so
# the effective limit is the one below times the number of workers.
Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

sign_in_path = "/users/sign_in"

# Per IP: stops one client from trying many passwords (or many accounts) quickly.
Rack::Attack.throttle("sign_in/ip", limit: 5, period: 20.seconds) do |req|
  req.ip if req.post? && req.path == sign_in_path
end

# Per account: stops a slow or distributed attack on one email, whatever the IP.
{ "sign_in/email/minute" => [5, 1.minute], "sign_in/email/hour" => [20, 1.hour] }
  .each do |name, (limit, period)|
    Rack::Attack.throttle(name, limit:, period:) do |req|
      next unless req.post? && req.path == sign_in_path

      user = req.params["user"]
      user["email"].to_s.downcase.strip.presence if user.is_a?(Hash)
    end
  end

# Rack::Attack runs after the session middleware, so the request can carry a flash: send the
# browser back to the form with a toast instead of a bare "429 Retry later" page.
Rack::Attack.throttled_responder = lambda do |request|
  req = ActionDispatch::Request.new(request.env)
  req.flash[:alert] = "Too many sign-in attempts. Try again later."
  req.commit_flash
  [303, { "Location" => sign_in_path, "Content-Type" => "text/html" }, []]
end
