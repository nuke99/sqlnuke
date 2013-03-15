require 'net/http'
require 'net/https'
require 'uri'
require 'pp'
require './lib/output'
require 'cgi'
require 'timeout'


class HTTP
include Notification
	def get(url)
		execute(url)
	end
	def post(url, options = { :method => :post })
		execute(url, options)
    end

	def proxy(ipandport)
		@proxy = ipandport
	end

	def header(header)

		if header
			@header = header
		else
			@header = ''
		end
	end

	def to_uri(url)
		url = url.gsub(/ /, '+')
    	begin
    		if !url.kind_of?(URI) 
    			url = URI.parse(url)
    		end
    	rescue URI::InvalidURIError
    		 print_error "Invalid url '#{url}'"
    		 exit
    	end
	    if (url.class != URI::HTTP && url.class != URI::HTTPS)
	    	raise URI::InvalidURIError, "Invalid url '#{url}'"
	    end
    	url
    end

	def execute(url,options ={})
		headers = @header
		retries = 42
		options = { :parameters => {}, :debug => false, 
                     :http_timeout => 60, :method => :get, 
                     :headers => headers, :redirect_count => 0, 
                     :max_redirects => 10 }.merge(options)
		url = self.to_uri(url)

		##Proxy Validation
		if @proxy		
			proxy = URI.parse(@proxy)
			http = Net::HTTP::Proxy(proxy.host, proxy.port).new(url.host, url.port.to_i)
		else
			http = Net::HTTP.new(url.host, url.port.to_i) 
		end

		http.open_timeout = http.read_timeout = options[:http_timeout]
         
        http.set_debug_output $stderr if options[:debug]

		#HTTPS Validation

		if url.scheme == 'https'
			http.use_ssl = true
			http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		end
		request = case options[:method]
		when :post
			 request = Net::HTTP::Post.new(url.request_uri)
             request.set_form_data(CGI::parse(options[:parameters]))
             request
		else
			
			request = Net::HTTP::Get.new(url.request_uri)
		end
		options[:headers].each { |key, value| request[key] = value }
		retries = 10  
		begin
			Timeout::timeout(5) do
				@response = http.request(request) 
			end
			
		rescue Timeout::Error,Errno::ECONNREFUSED
			if retries > 0
			    print_error("Timeout - Retrying...")
			    retries -= 1
			    retry
			  else
			    print_note("ERROR: Not responding after #{retries} retries!  Giving up!")
			    exit
			  end
		rescue
			print_note("ERROR: Please check your URL")
			exit
        end
        
		
		return @response

	end
end