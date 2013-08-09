require 'net/http'
require 'net/https'

def comment(user, repo, issue, command)

  unless HOMEBREW_GITHUB_API_TOKEN
    puts 'You need to create an API token: https://github.com/settings/applications'
    puts 'and then set HOMEBREW_GITHUB_API_TOKEN to use this command.'
    exit 1
  end

  post_comment(user, repo, issue, "```\n$ #{command}\n#{`#{command}`}```")
end

def post_comment(user, repo, issue, comment)

  path = "repos/#{user}/#{repo}/issues/#{issue}/comments"

  puts post(path, {'body' => comment})['html_url']
end

def http
  if !@http
    @http = Net::HTTP.new('api.github.com', 443)
    @http.use_ssl = true
  end
  @http
end

def post(path, data)
  request = Net::HTTP::Post.new("/#{path}")
  request['User-Agent'] = HOMEBREW_USER_AGENT
  request['Content-Type'] = 'application/json'
  request['Authorization'] = "token #{HOMEBREW_GITHUB_API_TOKEN}"
  request.body = Utils::JSON.dump(data)
  response = http.request(request)
  raise HTTP_Error, response if response.code != '201'
  Utils::JSON.load(response.body)
end

class HTTP_Error < RuntimeError
  def initialize response
    super "Error: HTTP #{response.code} #{response.message}"
  end
end

def usage
  puts 'usage: brew comment @[user/repo]#issue "command"'
end

if ARGV[0] =~ %r{^@(?:([\w\d\-]+)/([\w\d\-]+))?#(\d+)$} and ARGV[1]

  user = $1; repo = $2; issue = $3; command = ARGV[1]

  unless user and repo
    url = HOMEBREW_REPOSITORY.cd { `git config --get remote.origin.url` }

    if url =~ %r{github.com(?:/|:)([\w\d]+)/([\-\w\d]+)}
      user = $1; repo = $2;
    else
      raise 'Unable to determine fork.'
    end
  end

  comment(user, repo, issue, command)
else
  usage
  exit 1
end
