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
      data = request("/#{@pilot.character_id}/location/")
      return OpenStruct.new(id: nil, name: "<not online>") if data.empty?
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

    private

    def request(url, tries: 3)
      response = self.class.get(url, @options)
      raise StandardError, '401' if response.code == 401
      JSON.parse(response.body)
    rescue StandardError, '401'
      @logger.debug response
      token = Crest::RefreshToken.new(@pilot.refresh_token).process
      @pilot.update(token: token)
      @options[:headers][:Authorization] = "Bearer #{token}"
      retry if (tries -= 1) > 0
      raise
    end
  end

  class RefreshToken
    include HTTParty
    base_uri 'https://login.eveonline.com'

    def initialize(refresh_token)
      @refresh_token = refresh_token
    end

    def process
      auth = Base64.strict_encode64("#{ENV['CLIENT_ID']}:#{ENV['SECRET_KEY']}")
      headers = { Authorization: "Basic #{auth}" }
      response = self.class.post("/oauth/token", headers: headers,
                                 body: { grant_type: 'refresh_token',
                                         refresh_token: @refresh_token })
      JSON.parse(response.body)["access_token"]
    end
  end
end
