Rails.application.config.middleware.use OmniAuth::Builder do
  provider :eve_sso, ENV['SSO_ID'], ENV['SSO_SECRET'],
    scope: 'characterNavigationWrite esi-location.read_location.v1 esi-location.read_ship_type.v1'
end
