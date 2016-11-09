module ESI
  class Alliance
    include HTTParty
    base_uri "https://esi.tech.ccp.is/latest/alliances"

    def initialize(alliance_id: ENV["ALLIANCE_ID"])
      @alliance_id = alliance_id
    end

    def member_corp_ids
      response = self.class.get("/#{@alliance_id}/corporations/?datasource=tranquility")
      JSON.parse(response.body)
      end
    end
  end
end
