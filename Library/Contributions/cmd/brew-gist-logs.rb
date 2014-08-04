require 'formula'
require 'cmd/config'
require 'net/http'
require 'net/https'
require 'stringio'

def gist_logs f
  if ARGV.include? '--new-issue'
    unless HOMEBREW_GITHUB_API_TOKEN
      puts 'You need to create an API token: https://github.com/settings/applications'
      puts 'and then set HOMEBREW_GITHUB_API_TOKEN to use --new-issue option.'
      exit 1
    end
    repo = repo_name(f)
  end

  files = load_logs(f.name)

  append_config(files) if ARGV.include? '--config'
  append_doctor(files) if ARGV.include? '--doctor'

  url = create_gist(files)

  if ARGV.include? '--new-issue'
    url = new_issue(repo, "#{f.name} failed to build on #{MACOS_FULL_VERSION}", url)
  end

  ensure puts url if url
end

def load_logs name
  logs = {}
  dir = (HOMEBREW_LOGS/name)
  dir.children.sort.each do |file|
    logs[file.basename.to_s] = {:content => (file.size == 0 ? "empty log" : file.read)}
  end if dir.exist?
  raise 'No logs.' if logs.empty?
  logs
end

def append_config files
  s = StringIO.new
  Homebrew.dump_verbose_config(s)
  files["config.out"] = { :content => s.string }
end

def append_doctor files
  files['doctor.out'] = {:content => `brew doctor 2>&1`}
end

def create_gist files
  post('gists', {'public' => true, 'files' => files})['html_url']
end

def new_issue repo, title, body
  post("repos/#{repo}/issues", {'title' => title, 'body' => body})['html_url']
end

def http
  @http ||= begin
    uri = URI.parse('https://api.github.com')
    p = ENV['http_proxy'] ? URI.parse(ENV['http_proxy']) : nil
    if p.class == URI::HTTP or p.class == URI::HTTPS
      @http = Net::HTTP.new(uri.host, uri.port, p.host, p.port, p.user, p.password)
    else
      @http = Net::HTTP.new(uri.host, uri.port)
    end
    @http.use_ssl = true
    @http
  end
end

def post path, data
  request = Net::HTTP::Post.new("/#{path}")
  request['User-Agent'] = HOMEBREW_USER_AGENT
  request['Content-Type'] = 'application/json'
  if HOMEBREW_GITHUB_API_TOKEN
    request['Authorization'] = "token #{HOMEBREW_GITHUB_API_TOKEN}"
  end
  request.body = Utils::JSON.dump(data)
  response = http.request(request)
  raise HTTP_Error, response if response.code != '201'

  if !response.body.respond_to?(:force_encoding)
    body = response.body
  elsif response["Content-Type"].downcase == "application/json; charset=utf-8"
    body = response.body.dup.force_encoding(Encoding::UTF_8)
  else
    body = response.body.encode(Encoding::UTF_8, :undef => :replace)
  end

  Utils::JSON.load(body)
end

class HTTP_Error < RuntimeError
  def initialize response
    super "HTTP #{response.code} #{response.message}"
  end
end

def repo_name f
  dir = f.path.dirname
  url = dir.cd { `git config --get remote.origin.url` }
  unless url =~ %r{github.com(?:/|:)([\w\d]+)/([\-\w\d]+)}
    raise 'Unable to determine formula repository.'
  end
  "#{$1}/#{$2}"
end

def usage
  puts "usage: brew gist-logs [options] <formula>"
  puts
  puts "options: --config, --doctor, --new-issue"
end

if ARGV.formulae.length != 1
  usage
  exit 1
end

gist_logs(ARGV.formulae[0])
