require 'net/http'
require 'uri'
require 'json'

def send_request(text)
    uri = URI.parse("https://api.simsimi.vn/v1/simtalk")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/x-www-form-urlencoded"
    request.set_form_data("text" => text, "lc" => "id")

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.request(request)
    end

    if response.code.to_i == 200
        response_data = JSON.parse(response.body)
        return response_data['message'] || 'no msg'
    else
        return "err: #{response.code}"
    end
end

loop do
    print "you>: "
    input_text = gets.chomp

    break if ["exit", "quit", "keluar", "murtad"].include?(input_text.downcase)

    message = send_request(input_text)
    puts "bot>: #{message}"
end
