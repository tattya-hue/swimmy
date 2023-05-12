module Swimmy
  module Service
    dir = File.dirname(__FILE__) + "/service"

    autoload :Pokemoninfo, "#{dir}/pokemoninfo.rb"
    autoload :Geocoding,   "#{dir}/geocoding.rb"
    autoload :Weather,     "#{dir}/weather.rb"
    autoload :Anniversary, "#{dir}/anniversary.rb"
    autoload :Coronainfo,  "#{dir}/coronainfo.rb"
    autoload :RestaurantInfo, "#{dir}/restaurant_info.rb"
    autoload :CalendarService,    "#{dir}/calendar_service.rb"
  end
end
