require 'sinatra'
require 'active_resource'
require 'base64'
require 'cgi'
require 'openssl'
require './keys.rb'

get '/' do
	redirect to('/index.html')
end

get '/hi' do
	DIGEST = OpenSSL::Digest::Digest.new('sha1')
	hmac = OpenSSL::HMAC.digest(DIGEST, $privKey, $pubKey)
	return hmac
end