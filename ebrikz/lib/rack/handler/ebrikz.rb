require_relative 'response'
require 'socket'

module Rack
  module Handler
    class Ebrikz
      MAX_EOL = 2

      class << self
        def run(app, **options)
          socket = TCPServer.new(ENV['HOST'], ENV['PORT'])

          puts "Listening on #{ENV['HOST']}:#{ENV['PORT']}. Press CTRL+C to cancel."

          loop do
            Thread.start(socket.accept) do |client|
              handle_connection(client, app)
            end
          end
          # environment  = ENV['RACK_ENV'] || 'development'
          # default_host = environment == 'development' ? 'localhost' : nil
  
          # if !options[:BindAddress] || options[:Host]
          #   options[:BindAddress] = options.delete(:Host) || default_host
          # end
          # options[:Port] ||= 1234
  
          # @server = TCPServer.new(ENV['HOST'], ENV['PORT'])
          # puts "Listening on #{ENV['HOST']}:#{ENV['PORT']}. Press CTRL+C to cancel."
  
          # loop do
          #   Thread.start(server.accept) do |client|
          #     handler = Ebrikz::Handler.new(client)
          #     handler.establish_connection
          #   end
          # end
  
          # @server = ::WEBrick::HTTPServer.new(options)
          # @server.mount "/", Rack::Handler::WEBrick, app
          # yield @server if block_given?
          # @server.start
        end
  
        def valid_options
          # environment  = ENV['RACK_ENV'] || 'development'
          # default_host = environment == 'development' ? 'localhost' : '0.0.0.0'
  
          # {
          #   "Host=HOST" => "Hostname to listen on (default: #{default_host})",
          #   "Port=PORT" => "Port to listen on (default: 8080)",
          # }
        end
  
        def shutdown
          # if @server
          #   @server.shutdown
          #   @server = nil
          # end
        end
  
        def handle_connection(client, app)
          request_text = ''
          eol_count = 0

          loop do
            buf = client.recv(1)
            puts "#{client} #{buf}"
            request_text += buf
            eol_count += 1 if buf == "\n"

            if eol_count == MAX_EOL
              handle_request(request_text, client, app)
              break
            end
          end
        end

        def handle_request(request_text, client, app)
          # request = Request.new(request_text)
          # puts "#{client.peeraddr[3]}"

          # status, headers, body = app.call(env)
          status, headers, body = app.call({})
          response = Response.new(code: status, data: body)

          response.send(client)

          client.shutdown
        end
      end
    end

    # register 'ebrikz', 'Rack::Handler::Ebrikz'
  end
end
