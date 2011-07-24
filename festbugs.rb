require 'sinatra'
require 'active_resource'
require 'base64'
require 'cgi'
require 'openssl'
require 'net/http'

def urlSafeBase64Decode(base64String)
  return Base64.decode64(base64String.tr('-_','+/'))
end

def urlSafeBase64Encode(raw)
  return Base64.encode64(raw).tr('+/','-_')
end

get '/' do
	redirect to('/index.html')
end

get '/search/:name' do
	DIGEST = OpenSSL::Digest::Digest.new('sha1')
	url = "/events?title=#{CGI::escape(params[:name])}&key=#{ENV['FESTIVAL_KEY']}"
	sig = OpenSSL::HMAC.hexdigest(DIGEST, ENV['FESTIVAL_SECRET'], url)
	url = "http://api.festivalslab.com"+url+"&signature=#{sig}"
	url = URI.parse(url)
	# start the http object
	resp = Net::HTTP.new(url.host).start{|http|
		http.get(url.path+"?"+url.query, {'Accept'=>'application/json'})
	}
	resp_text = resp.body
	return resp_text
end