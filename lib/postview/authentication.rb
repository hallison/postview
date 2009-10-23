module Postview

# Copyright (c) 2009 Hallison Batista
module Authentication

  # Returns a HTTP Basic authentication.
  def authentication
    @authentication ||= Rack::Auth::Basic::Request.new(request.env)
  end
 
  def username
    env["REMOTE_USER"] || authentication.credentials.first
  end

  def password
    authentication.credentials.last
  end

  # Run HTTP Basic authentication.
  def authenticate!
    headers "WWW-Authenticate" => %(Basic realm="#{@site.title}") and
    @error_message = "Not authorized\n" and throw(:halt, [401, erb(:error)]) and
    return unless authenticated?
  end

  def authenticated?
    authentication.provided?   &&
    authentication.basic?      &&
    authentication.credentials &&
    @site.authenticate?(username, password)
  end

end # module Authorization

end # module Postview

