require 'sinatra'
require 'active_resource'
require 'base64'
require 'cgi'
require 'openssl'
require 'net/http'
require 'sequel'
require 'json'

DB = Sequel.connect(ENV['DATABASE_URL'] || "amalgalite://blog.db")

# data models!

class Pond < Sequel::Model
	many_to_many :events
end
class Event < Sequel::Model
	many_to_many :ponds
end

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

get '/pond/create/:events' do
	# generate a new pond
	ponds = DB[:ponds]
	@pond = Pond.new()
	@pond.save()
	p params[:events].split(" ")
	# TODO: check to see if there is a pond that already contains the bugs that we requested for this pond
	
	# for each of the events that were chucked at us
	params[:events].split(" ").each{|event|
		# find or create the associated event in the db
		@event = Event.find_or_create(:url => event)
		if not @pond.events.include?(@event)
			@pond.add_event(@event)
		end
	}
	return @pond[:id].to_s
end

get '/pond/:id' do
	# return the ids for all the events in the pond as a json array
	@pond = Pond.find(:id => params[:id])
	event_ids = []
	@pond.events.each{|event|
		event_ids.push(event[:url].to_s)
	}
	return event_ids.to_json
end