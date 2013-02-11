module Homebrew extend self
  def gh_auth
    abort 'usage: brew gh-auth' if ARGV.named.count != 0
    print 'Github username: '
    raise 'Username is required!' if (un = gets.chomp).empty?
    print 'Password: '
    `stty -echo`; pw = gets.chomp; `stty echo`; puts
    raise 'Password is required!' if pw.empty?
    require_magic 'uri', 'net/http', 'net/https', 'vendor/multi_json'
    uri = URI.parse('https://api.github.com/authorizations')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path)
    request.add_field('User-Agent', HOMEBREW_USER_AGENT)
    request.add_field('Content-Type', 'application/json')
    request.basic_auth un, pw
    request.body = MultiJson.dump({'scopes' => ['repo', 'gist'], 'note' => 'Mac Homebrew'})
    response = http.request(request)
    if (response.code == '201')
      f_p = File.expand_path('~/.brew')
      File.open(f_p, 'w').write(response.body)
      puts "#{Tty.white}Successfully authorized!#{Tty.reset}"
      puts f_p
    else
      puts "#{Tty.white}Authorization failed!#{Tty.reset}"
      puts "Response: #{response.code} #{response.message}"
    end
  end
end
