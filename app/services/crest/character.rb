module Crest
  class Character
    include HTTParty
    base_uri "https://crest-tq.eveonline.com/characters"

    def initialize(pilot, logger: Rails.logger)
      @pilot = pilot
      @logger = logger
      @options = { headers: { Authorization: "Bearer #{@pilot.token}" } }
    end

    def location
      invalid = OpenStruct.new(id: nil, name: "<not online>")
      return invalid if @pilot.refresh_token.nil?
      data = request("/#{@pilot.character_id}/location/")
      return invalid if data.empty?
      OpenStruct.new(system_id: data["solarSystem"]["id"],
                          name: data["solarSystem"]["name"])
    end

    def corporation
      data = request("/#{@pilot.character_id}/")
      OpenStruct.new(id: data["corporation"]["id"],
                   name: data["corporation"]["name"],
                   logo: data["corporation"]["logo"]["64x64"]["href"])
    end

    def name
      data = request("/#{@pilot.character_id}/")
      data["name"]
    end

    def set_destination(solar_system_id)
      @options[:body] = {
        clearOtherWaypoints: false,
        first: false,
        solarSystem: {
          href: "https://crest-tq.eveonline.com/solarsystems/#{solar_system_id}/",
          id: solar_system_id.to_i
        }
      }.to_json
      @options[:headers]['Content-Type'] = 'application/json'
      send("/#{@pilot.character_id}/ui/autopilot/waypoints/")
    end

    private

    def request(url, tries: 3)
      response = self.class.get(url, @options)
      raise StandardError, '401' if response.code == 401
      JSON.parse(response.body)
    rescue StandardError, '401'
      @logger.warn { url: url, response: response }
      token = Crest::RefreshToken.new(@pilot.refresh_token).process
      @pilot.update(token: token["access_token"], refresh_token: token["refresh_token"])
      @options = { headers: { Authorization: "Bearer #{token["access_token"]}" } }
      retry if (tries -= 1) > 0
      []
    end

    def send(url, tries: 3)
      response = self.class.post(url, @options)
      raise StandardError, '401' if response.code == 401
    rescue StandardError, '401'
      @logger.warn { url: url, response: response }
      token = Crest::RefreshToken.new(@pilot.refresh_token).process
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
      auth = Base64.strict_encode64("#{Rails.application.secrets.crest_id}:#{Rails.application.secrets.crest_secret}")
      headers = { Authorization: "Basic #{auth}" }
      response = self.class.post("/oauth/token", headers: headers,
                                 body: { grant_type: 'refresh_token',
                                         refresh_token: @refresh_token })
      JSON.parse(response.body)
    end
  end
end
