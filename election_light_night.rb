require 'HTTParty'
require 'Nokogiri'
require 'JSON'
require 'Pry'
require 'csv'

# Navigate to http://www.developers.meethue.com/documentation/getting-started 
# for the following three variables
username=(update with your generated Hue username)
ip=(update with your Hue Bridge IP address)
light_id=(update with your target light ID)

# Color codes
white=13544
blue=47125
red=65413

base_request='curl -s -XPUT "http://' + ip + '/api/' + username 
base_request=base_request + '/lights/' + light_id
base_request=base_request + '/state" --header "Content-Type: application/json"'
base_request=base_request + ' --header "Accept: application/json"'
base_request=base_request + '--data "{\"on\":true, \"sat\":254, \"bri\":254, \"hue\":'

page = HTTParty.get('http://www.politico.com/2016-election/results/map/president')

parse_page = Nokogiri::HTML(page)

hillary_electoral_votes = parse_page.css('.macro').children[0].text.to_i
trump_electoral_votes = parse_page.css('.macro').children[2].text.to_i

if hillary_electoral_votes > trump_electoral_votes
  # shell out and make blue
  make_blue=base_request + blue + '}"'
  exec make_blue
elsif trump_electoral_votes > hillary_electoral_votes
  # shell out and make red
  make_red=base_request + red + '}"'
  exec make_red
else
  # shell out and make white
  make_white=base_request + white + '}"'
  exec make_white