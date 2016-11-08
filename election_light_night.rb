require 'httparty'
require 'nokogiri'
require 'json'

# Navigate to http://www.developers.meethue.com/documentation/getting-started 
# for the following three variables
@username="h3mao-ggdyHFYjt6OSx1ZFBABoWoDsJHiTszMET2"
@ip="http://192.168.1.203"
@light_id="3"

# Color codes
WHITE=14956
BLUE=47125
RED=65413

def change_light(color)
  data={"on":true, "sat":254, "bri":254, "hue":color}

  response = HTTParty.put("#{@ip}/api/#{@username}/lights/#{@light_id}/state",  
                           :body => data.to_json,
                           :headers => { "Content-Type" => 'application/json'})
end


page = HTTParty.get('http://www.politico.com/2016-election/results/map/president')

parse_page = Nokogiri::HTML(page)

hillary_electoral_votes = parse_page.css('.macro').children[0].text.to_i
trump_electoral_votes = parse_page.css('.macro').children[2].text.to_i

if hillary_electoral_votes > trump_electoral_votes
  change_light(BLUE)
elsif trump_electoral_votes > hillary_electoral_votes
  change_light(RED)
else
  change_light(WHITE)
end
