require "formula"
require "cmd/config"
require "net/http"
require "net/https"
require "stringio"

module Homebrew
  def gistify_logs(f)
    files = load_logs(f.logs)

    s = StringIO.new
    Homebrew.dump_verbose_config(s)
    files["config.out"] = { :content => s.string }
    files["doctor.out"] = { :content => `brew doctor 2>&1` }
    unless f.core_formula?
      tap = <<-EOS.undent
        Formula: #{f.name}
        Tap: #{f.tap}
        Path: #{f.path}
      EOS
      files["tap.out"] = { :content => tap }
    end

    url = create_gist(files)

    if ARGV.include?("--new-issue") || ARGV.switch?("n")
      auth = :AUTH_TOKEN

      unless HOMEBREW_GITHUB_API_TOKEN
        puts "You can create a personal access token: https://github.com/settings/tokens"
        puts "and then set HOMEBREW_GITHUB_API_TOKEN as authentication method."
        puts

        auth = :AUTH_BASIC
      end

      url = new_issue(f.tap, "#{f.name} failed to build on #{MACOS_FULL_VERSION}", url, auth)
    end

    puts url if url
  end

  # Hack for ruby < 1.9.3
  def noecho_gets
    system "stty -echo"
    result = $stdin.gets
    system "stty echo"
    puts
    result
  end

  def login(request)
    print "GitHub User: "
    user = $stdin.gets.chomp
    print "Password: "
    password = noecho_gets.chomp
    puts
    request.basic_auth(user, password)
  end

  def load_logs(dir)
    logs = {}
    dir.children.sort.each do |file|
      contents = file.size? ? file.read : "empty log"
      logs[file.basename.to_s] = { :content => contents }
    end if dir.exist?
    raise "No logs." if logs.empty?
    logs
  end

  def create_gist(files)
    post("/gists", "public" => true, "files" => files)["html_url"]
  end

  def new_issue(repo, title, body, auth)
    post("/repos/#{repo}/issues", { "title" => title, "body" => body }, auth)["html_url"]
  end

  def http
    @http ||= begin
      uri = URI.parse("https://api.github.com")
      p = ENV["http_proxy"] ? URI.parse(ENV["http_proxy"]) : nil
      if p.class == URI::HTTP || p.class == URI::HTTPS
        @http = Net::HTTP.new(uri.host, uri.port, p.host, p.port, p.user, p.password)
      else
        @http = Net::HTTP.new(uri.host, uri.port)
      end
      @http.use_ssl = true
      @http
    end
  end

  def make_request(path, data, auth)
    headers = {
      "User-Agent"   => HOMEBREW_USER_AGENT,
      "Accept"       => "application/vnd.github.v3+json",
      "Content-Type" => "application/json"
    }

    if auth == :AUTH_TOKEN || (auth.nil? && HOMEBREW_GITHUB_API_TOKEN)
      headers["Authorization"] = "token #{HOMEBREW_GITHUB_API_TOKEN}"
    end

    request = Net::HTTP::Post.new(path, headers)

    login(request) if auth == :AUTH_BASIC

    request.body = Utils::JSON.dump(data)
    request
  end

  def post(path, data, auth = nil)
    request = make_request(path, data, auth)

    case response = http.request(request)
    when Net::HTTPCreated
      Utils::JSON.load get_body(response)
    else
      raise "HTTP #{response.code} #{response.message} (expected 201)"
    end
  end

  def get_body(response)
    if !response.body.respond_to?(:force_encoding)
      response.body
    elsif response["Content-Type"].downcase == "application/json; charset=utf-8"
      response.body.dup.force_encoding(Encoding::UTF_8)
    else
      response.body.encode(Encoding::UTF_8, :undef => :replace)
    end
  end

  def gist_logs
    if ARGV.resolved_formulae.length != 1
      puts "usage: brew gist-logs [--new-issue|-n] <formula>"
      Homebrew.failed = true
      return
    end

    gistify_logs(ARGV.resolved_formulae[0])
  end
end
