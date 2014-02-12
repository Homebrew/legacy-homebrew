require 'net/http'
require 'net/https'
require 'uri'
require 'fileutils'
require 'utils/json'

module Homebrew extend self

  def __github_token
    # Get Github credentials
    user = get_password("Enter your Github username: ")
    puts
    pass = get_password("Enter password for user '#{user}': ")
    puts

    # POST request for API TOKEN
    params = {"note" => "homebrew"}
    uri = URI.parse('https://api.github.com/authorizations')
    req = Net::HTTP::Post.new(uri.path, {'User-Agent' => 'HomeBrew', 'Content-Type' => 'application/json'})
    req.body = Utils::JSON.dump(params)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    resp = http.start {|h| h.request(req) }

    # make ~/.config dir
    FileUtils.mkdir(File.join(ENV['HOME'], '.config')) unless File.exists?(File.join(ENV['HOME'], '.config'))

    # Save API Token to file
    File.open(File.join(ENV['HOME'], '.config', 'homebrew'), 'w', 0600) do |file|
      file << /,"token":"(.*?)",/.match(resp.body)[1]
    end
  end

  def get_password(prompt="Password: ")
    `read -s -p "#{prompt}" password; echo $password`.chomp
  end

end
