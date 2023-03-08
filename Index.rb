require 'net/http'
require 'JSON'
require 'uri'
require_relative 'config'
require 'date'

cashed_response = {}
loc = Net::HTTP.get(URI('https://ipapi.co/json/'))
specify = JSON.parse(loc)
longitude = specify['longitude']
latitude = specify['latitude']

#  check to see if you recieve the correct data for the api well need long and lat

# puts "Long: #{longitude}, Lat: #{latitude}"

# Here is a cached set of responses for the Weather conditions finding

weather_codes = {
  0 => ['Clear sky'],
  1 => ['Mainly clear'],
  2 => ['partly cloudy'],
  3 => ['overcast'],
  45 =>	['Fog and depositing rime fog'],
  48 =>	['Fog and depositing rime fog'],
  51 =>	['Drizzle: Light'],
  53 =>	['Drizzle: Moderate'],
  55 =>	['Drizzle: Dense intensity'],
  56 =>	['Freezing Drizzle: Light'],
  57 =>	['Freezing Drizzle: Dense intensity'],
  61 =>	['Rain: Slight'],
  63 =>	['Rain: Moderate'],
  65 =>	['Rain: Heavy intensity'],
  66 =>	['Freezing Rain: Light'],
  67 =>	['Freezing Rain: Heavy intensity'],
  71 =>	['Snow fall: Slight'],
  73 =>	['Snow fall: Moderate'],
  75 =>	['Snow fall: Heavy intensity'],
  77 =>	['Snow grains'],
  80 =>	['Rain showers: Slight'],
  81 =>	['Rain showers: Moderate'],
  82 =>	['Rain showers: Violent'],
  85 =>	['Snow showers: Slight'],
  86 =>	['Snow showers: Heavy'],
  95 =>	['Thunderstorm: Slight or moderate']
}

# Setting up a Variable for the current Date

today = Date.today

# Establishing a variable to calulate the date of next week.

next_week = today + 7

# Date will funtion as a counter

date = today
# Looping through the days until it reaches the date for next week

until date >= next_week

  # Checks to see if response has already been submited

  if cashed_response[date]
    puts cashed_response[date]
  else
    response = Net::HTTP.get(URI("https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&timezone=auto&daily=temperature_2m_max&daily=temperature_2m_min&temperature_unit=fahrenheit&start_date=#{date}&end_date=#{date}&daily=weathercode"))
    cashed_response[date] = response
  end

  # This will gather the cached responses and allow you to retrieve data

  forecast = JSON.parse(response)
  condition = forecast['daily']['weathercode'][0]
  weather = weather_codes[condition][0].capitalize
  puts "#{date.strftime('%m-%d-%Y')} - #{specify['city']}, #{specify['region']}:"
  puts "Condition: #{weather}"
  puts "High: #{forecast['daily']['temperature_2m_max'][0]}˚F | " + "Low: #{forecast['daily']['temperature_2m_min'][0]}˚F \n\n"
  date += 1
end
