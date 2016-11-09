Rails.application.config.middleware.use OmniAuth::Builder do
  provider :eve_sso, ENV['SSO_ID'], ENV['SSO_SECRET'],
    scope: 'characterLocationRead characterNavigationWrite remoteClientUI'
end
