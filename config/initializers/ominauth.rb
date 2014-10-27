Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, Settings.google.client_id, Settings.google.client_secret,
  {
    scope: ["plus.login", "plus.me", "userinfo.email", "userinfo.profile",
      "https://mail.google.com/", "gmail.compose", "gmail.modify",
      "gmail.readonly", "calendar", "calendar.readonly"],
    access_type: 'offline'
  }
end