#!/usr/bin/ruby
 require 'optparse'
 require './class/methods'
 require 'yaml'

 options = {}
 config = YAML.load_file("config.yml")

 optparse =  OptionParser.new do|opts|
 	
 	opts.banner = "
     _______.  ______      __      .__   __.  __    __   __  ___  _______ 
    /       | /  __  \\    |  |     |  \\ |  | |  |  |  | |  |/  / |   ____|
   |   (----`|  |  |  |   |  |     |   \\|  | |  |  |  | |  '  /  |  |__   
    \\   \\    |  |  |  |   |  |     |  . `  | |  |  |  | |    <   |   __|  
.----)   |   |  `--'  '--.|  `----.|  |\\   | |  `--'  | |  .  \\  |  |____ 
|_______/     \\_____\\_____\\_______||__| \\__|  \\______/  |__|\\__\\ |_______|
                                                
 	#{config['name']} | #{config['discription']} . v #{config['version']}
 	---------------------------------------------------------------------
 	Usage: #$0 [options] [terms] "

 	##SQL Injection query option
 	options[:url] = nil
 	opts.on('-u', '--url URL', "Link with '#{config['grabber']}' ex: http://tar.com/?id=1+UNION+SELECT+1,#{config['grabber']},2--" ) do|inj|
 		options[:url] = inj
 	end

 	##POST Method Data

 	options[:data] = false
 	opts.on( "-d", "--data DATA",String,"POST DATA ex: id=-1+Union+Select+null,#{config['grabber']},null--&name=John" ) do|data|
 		options[:data] = data
 	end

 	##Hex Convert Read Files

 	options[:hex] = false
 	opts.on('-x', '--hex' , 'Hex Conversion') do |bool|
 		options[:hex] = bool
 	end

 	options[:proxy] = false
 	opts.on('--proxy http://IP:PORT' , 'HTTP Proxy') do |proxy|
 		options[:proxy] = proxy
 	end

 	##Target OS for sql injection
 	
 	opts.on('--os (linux,win)',['linux','win'], 'Target Server OS (linux,win)') do |os|
 		options[:os] = os
 	end


 	##UserAgent 

 	options[:agent] = false
 	opts.on("--agent AGENT ",String, "User-Agent for the header" ) do|agent|
 		options[:agent] = agent
 	end

 	##Referer 

 	options[:ref] = false
 	opts.on("--ref REFERER ",String, "Referer for the header" ) do|ref|
 		options[:ref] = ref
 	end

 	##Cookie 

 	options[:cookie] = false
 	opts.on("--cookie COOKIE ",String, "Cookie for the header" ) do|cookie|
 		options[:cookie] = cookie
 	end

 	opts.on( '-h', '--help', 'Information about commands' ) do
     puts opts
     exit
   	end

 end


method = Methods.new

begin
	optparse.parse!

	method.cookie(options[:cookie]) 
	method.referer(options[:ref])
	method.agent(options[:agent]) 
	method.hex(options[:hex]) if options[:hex]
	method.proxy(options[:proxy]) if options[:proxy]
	method.os(options[:os]) if options[:os]	
	method.data(options[:data]) if options[:data]
	method.url(options[:url]) if options[:url]


rescue OptionParser::InvalidOption, OptionParser::MissingArgument, OptionParser::InvalidArgument     #
  puts $!.to_s                                                           # Friendly output when parsing fails
  puts optparse                                                          #
  exit                                                                   #
end 


# Check required conditions
if ARGV.empty?
  puts optparse
  exit(-1)
end