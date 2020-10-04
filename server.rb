# require "rack"
# require "thin"

# require "ebrikz/lib/rack/handler/ebrikz"
require_relative "ebrikz/lib/rack/handler/ebrikz"

class HelloWorld
  def call(env)
    [ 200, { "Content-Type" => "text/plain" }, ["Hello World"] ]
  end
end

Rack::Handler::Ebrikz.run(HelloWorld.new)
