require "sinatra"
require "sinatra/reloader"

require "http"
require "json"

base_url = "https://api.exchangerate.host"

symbols = nil

get("/") do
  if symbols.nil?
    symbols = get_symbols(base_url)
  end
  @symbols = symbols
  erb :from

end

get("/:from") do
  if symbols.nil?
    symbols = get_symbols(base_url)
  end
  @symbols = symbols
  @from = params[:from]

  erb :to

end

get("/:from/:to") do

  @from = params[:from]
  @to = params[:to]
  @result = convert_currency(base_url, @from, @to)

  erb :results

end

def get_symbols(base_url)

  response = JSON.parse(HTTP.get("#{base_url}/symbols"))
  return response["symbols"].keys

end

def convert_currency(base_url, from, to)

  response = JSON.parse(HTTP.get("#{base_url}/convert?from=#{from}&to=#{to}"))
  return response["result"]

end
