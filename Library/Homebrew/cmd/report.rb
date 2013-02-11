require 'formula'

module Homebrew extend self
  def report
    abort 'Github oAuth token missing. Run: brew gh-auth' if gh_token.empty?
    abort 'usage: brew report [formula]' if ARGV.named.count != 1
    f_pn = (f = ARGV.formulae[0]).path
    Dir.chdir((f_pn.symlink? ? f_pn.realpath.dirname : HOMEBREW_REPOSITORY).to_s) do
      if `git config --get remote.origin.url` =~ %r{https://github.com/(\w+)/([\-\w]+)}
        ohai 'Running brew doctor'
        doctor = `brew doctor`
        ohai 'Running brew --config'
        config = `brew --config`
        response = upload_logs f
        body = ''
        response['files'].sort.each { |f_n, x| body << "* [#{f_n}](#{x['raw_url']})\n" }
        body << "\n```\n$ brew doctor\n#{doctor}\n```\n```\n$ brew --config\n#{config}\n```"
        open_issue f, $1, $2, body
      end
    end
  end

  def upload_logs f
    ohai 'Uploading logs'
    l_pn = HOMEBREW_LOGS/f.name
    files = {}
    if l_pn.directory?
      l_pn.children.each do |l_f|
        print l_f if l_f.basename.to_s =~ %r{0[\d].[\w]+|config.log}
        if l_f.size < 3 * 1024 * 1024
          files[l_f.basename.to_s] = {'content' => l_f.read}
          puts
        else
          puts ' - too big, skipping...'
        end
      end
    end
    abort 'No Logs to upload' if files.count == 0
    return post 'https://api.github.com/gists', {'description' => "#{f.name} #{f.version}", 'public' => true, 'files' => files}
  end

  def open_issue f, gh_user, gh_repository, body
    ohai 'Opening issue'
    title = "#{f.name} #{f.version} failed to build on #{MACOS_FULL_VERSION}"
    response = post "https://api.github.com/repos/#{gh_user}/#{gh_repository}/issues", {'title' => title, 'body' => body}
    puts "Issue: ##{response['number']}"
    puts response['http_url']
  end

  def post url, data
    require_magic 'uri', 'net/http', 'net/https', 'vendor/multi_json'
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path)
    request.add_field('User-Agent', HOMEBREW_USER_AGENT)
    request.add_field('Authorization', 'token ' + gh_token)
    request.add_field('Content-Type', 'application/json')
    request.body = MultiJson.dump(data)
    #http.set_debug_output $stderr
    response = http.request(request)
    if response.code != '201'
      onoe 'Github API Error.'
      puts "Response: #{response.code} #{response.message}"
      exit 1
    end
    return MultiJson.decode(response.body)
  end

  def gh_token
    gh_token ||= (pn = Pathname.new('~/.brew').expand_path).file? ? MultiJson.decode(File.open(pn.to_s, 'r').read)['token'] : ''
  end
end
