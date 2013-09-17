require 'JSON'
require 'rest-client'

response = RestClient.get('http://makerblog.herokuapp.com/posts', 
  {:accept => :json})

# puts response
# puts response.code
# puts response.class

# posts = JSON.parse(response)
# puts posts.class
# puts posts

module MakerBlog
  class Client
    def initialize
      @posts = RestClient.get 'http://makerblog.herokuapp.com/posts', 
        :accept => :json
      @posts = JSON.parse(@posts)
      @post_url = 'http://makerblog.herokuapp.com/posts'
    end


    def list_posts
     posts = RestClient.get 'http://makerblog.herokuapp.com/posts', 
        :accept => :json
      response_code(posts.code)
      posts = JSON.parse(posts)
      posts.each do |post|
        puts post['id'].to_s + ": " + post['name'].to_s + " " + post['title'] 
        puts post['content']
      end
      
    end

    def show_post(id)
      response = RestClient.get @post_url + "/#{id}", :accept => :json
      response = JSON.load(response)
      puts response['id'].to_s + ": " + response['name'].to_s + " " + response['title'] 
      puts response['content']
      response_code(response.code)
    end

    def create_post(name, title, content)
      @post_url
      payload = {:post => {'name' => name, 'title' => title, 'content' => content}}
      response = RestClient.post @post_url, payload.to_json, :content_type => :json,
        :accept => :json
      response_code(response.code)
    end

    def edit_post(id, options = {})
      params = {}

      params[:name] = options[:name] unless options[:name].nil?
      params[:title] = options[:title] unless options[:title].nil?
      params[:content] = options[:content] unless options[:content].nil?

      response = RestClient.put @post_url + "/#{id}", {:post => params}.to_json, 
      :content_type => :json, :accept => :json
      response = JSON.load(response)
      puts "#{response['id'].to_s} : #{response['name'].to_s}, said #{response['content'].to_s}"
      # puts response
      response_code(response.code)
    end

    def delete_post(id)
      response = RestClient.delete @post_url + "/#{id}", :accept => :json
      # response = JSON.load(response)
      # puts "Response code: " + response.code.to_s
      response_code(response.code)
      # if response.code != 204
      # end
    end

    private
      def response_code(code)
        code = code.to_s

        case code[0]
          when '1' 
            puts "Inconclusive response"
          when '2' 
            puts "Success"
          when '3' 
            puts "Redirection"
          when '4' 
            puts "Unauthorized, forbidden, or not found"
          when '5'  
            puts "Server Error"
        end
      end
  end
end

client = MakerBlog::Client.new
client.list_posts
# client.show_post(77)

# client.create_post('dudemandude', "The NOT world is on fire", "false")

# client.edit_post(96, {:content => "I lost my pants"})
# client.delete_post(68)