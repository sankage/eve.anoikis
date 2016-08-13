module Crest
  class Alliance
    include HTTParty
    base_uri "https://crest-tq.eveonline.com/alliances"

    def initialize(alliance_id: ENV["ALLIANCE_ID"])
      @alliance_id = alliance_id
    end

    def member_corps
      response = self.class.get("/#{@alliance_id}/")
      result = JSON.parse(response.body)
      result["corporations"].map do |corp|
        OpenStruct.new(name: corp["name"],
                         id: corp["id"],
                       logo: corp["logo"]["64x64"]["href"])
      end
    end
  end
end
