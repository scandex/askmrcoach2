require 'faraday'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

Taric.configure! do |config|
  config.api_key = ENV["RIOT_API"]
  
  config.adapter = :typhoeus # default is Faraday.default_adapter
end