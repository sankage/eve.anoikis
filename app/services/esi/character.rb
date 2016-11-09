module ESI
  class InvalidToken < StandardError; end
  class Character
    include HTTParty
    base_uri "https://esi.tech.ccp.is/latest/characters"

    def initialize(pilot, logger: Rails.logger)
      @pilot = pilot
      @logger = logger
      @options = { headers: { Authorization: "Bearer #{@pilot.token}" } }
    end

    def location_id
      return if @pilot.refresh_token.nil?
      data = request("/#{@pilot.character_id}/location/?datasource=tranquility")
      return if data.empty?
      data["solar_system_id"]
    end

    def corporation_id
      data = request("/#{@pilot.character_id}/?datasource=tranquility")
      data["corporation_id"]
    end

    def name
      data = request("/#{@pilot.character_id}/?datasource=tranquility")
      data["name"]
    end

    private

    def request(url, tries: 3)
      response = self.class.get(url, @options)
      raise InvalidToken, '400' if response.code == 401
      JSON.parse(response.body)
    rescue InvalidToken, '400'
      @logger.debug response
      token = ESI::RefreshToken.new(@pilot.refresh_token).process
      @pilot.update(token: token["access_token"], refresh_token: token["refresh_token"])
      @options = { headers: { Authorization: "Bearer #{token["access_token"]}" } }
      retry if (tries -= 1) > 0
      []
    end

    def send(url, tries: 3)
      response = self.class.post(url, @options)
      raise InvalidToken, '400' if response.code == 401
    rescue InvalidToken, '400'
      @logger.debug response
      token = ESI::RefreshToken.new(@pilot.refresh_token).process
      @pilot.update(token: token["access_token"], refresh_token: token["refresh_token"])
      @options = { headers: { Authorization: "Bearer #{token["access_token"]}" } }
      retry if (tries -= 1) > 0
    end
  end

  class RefreshToken
    include HTTParty
    base_uri 'https://login.eveonline.com'

    def initialize(refresh_token)
      @refresh_token = refresh_token
    end

    def process
      auth = Base64.strict_encode64("#{Rails.application.secrets.sso_id}:#{Rails.application.secrets.sso_secret}")
      headers = { Authorization: "Basic #{auth}" }
      response = self.class.post("/oauth/token", headers: headers,
                                 body: { grant_type: 'refresh_token',
                                         refresh_token: @refresh_token })
      JSON.parse(response.body)
    end
  end
end
