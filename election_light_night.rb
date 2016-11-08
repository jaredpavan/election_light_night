#!/usr/bin/env ruby

require 'httparty'
require 'nokogiri'
require 'json'

# Navigate to http://www.developers.meethue.com/documentation/getting-started 
# for the following three variables
@username="replace with your user name"
@ip="replace with your Hue Bridge IP"
@light_id="replace with your target light"

# CONSTANT Color codes
WHITE=14956
BLUE=47125
RED=65413

# Define helper methods
def change_light(color)
  data={"on":true, "sat":254, "bri":254, "hue":color}

  response = HTTParty.put("#{@ip}/api/#{@username}/lights/#{@light_id}/state",  
                           :body => data.to_json,
                           :headers => { "Content-Type" => 'application/json'})
end

# Celebrate victory for 60 seconds
def declare_victory(color)
  loop do
    change_light(color)
    sleep(0.5)
    change_light(WHITE)
    sleep(0.5)
  end
end

# Run vote checker every 60 seconds
loop do
  page = HTTParty.get('http://www.politico.com/2016-election/results/map/president')
  parse_page = Nokogiri::HTML(page)
  hillary_electoral_votes = parse_page.css('.type-democrat').css('.macro').children.first.text.to_i
  trump_electoral_votes = parse_page.css('.type-republican').css('.macro').children.first.text.to_i

  if hillary_electoral_votes >= 270
    declare_victory(BLUE)
  elsif trump_electoral_votes >= 270
    declare_victory(RED)
  elsif hillary_electoral_votes > trump_electoral_votes
    change_light(BLUE)
  elsif trump_electoral_votes > hillary_electoral_votes
    change_light(RED)
  else
    change_light(WHITE)
  end
  
  puts "Hillary: #{hillary_electoral_votes} Trump: #{trump_electoral_votes}"
  sleep(60)
end
