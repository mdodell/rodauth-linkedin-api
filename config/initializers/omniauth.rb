Rails.application.config.middleware.use OmniAuth::Builder do
    provider :linkedin, ENV['CLIENT'], ENV["SECRET"], scope: ["r_emailaddress", "r_liteprofile"],
    fields: ['id', 'first-name', 'last-name', 'email-address'], callback_path: "/auth/linkedin/callback", provider_ignores_state: true
  end