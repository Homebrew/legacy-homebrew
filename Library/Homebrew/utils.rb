require "pathname"
require "exceptions"
require "utils/json"
require "utils/inreplace"
require "utils/popen"
require "utils/fork"
require "utils/git"
require "open-uri"

class Tty
  class << self
    def tick
      # necessary for 1.8.7 unicode handling since many installs are on 1.8.7
      @tick ||= ["2714".hex].pack("U*")
    end

    def cross
      # necessary for 1.8.7 unicode handling since many installs are on 1.8.7
      @cross ||= ["2718".hex].pack("U*")
    end

    def strip_ansi(string)
      string.gsub(/\033\[\d+(;\d+)*m/, "")
    end

    def blue
      bold 34
    end

    def white
      bold 39
    end

    def red
      underline 31
    end

    def yellow
      underline 33
    end

    def reset
      escape 0
    end

    def em
      underline 39
    end

    def green
      bold 32
    end

    def gray
      bold 30
    end

    def highlight
      bold 39
    end

    def width
      `/usr/bin/tput cols`.strip.to_i
    end

    def truncate(str)
      str.to_s[0, width - 4]
    end

    private

    def color(n)
      escape "0;#{n}"
    end

    def bold(n)
      escape "1;#{n}"
    end

    def underline(n)
      escape "4;#{n}"
    end

    def escape(n)
      "\033[#{n}m" if $stdout.tty?
    end
  end
end

def ohai(title, *sput)
  title = Tty.truncate(title) if $stdout.tty? && !ARGV.verbose?
  puts "#{Tty.blue}==>#{Tty.white} #{title}#{Tty.reset}"
  puts sput
end

def oh1(title)
  title = Tty.truncate(title) if $stdout.tty? && !ARGV.verbose?
  puts "#{Tty.green}==>#{Tty.white} #{title}#{Tty.reset}"
end

# Print a warning (do this rarely)
def opoo(warning)
  $stderr.puts "#{Tty.yellow}Warning#{Tty.reset}: #{warning}"
end

def onoe(error)
  $stderr.puts "#{Tty.red}Error#{Tty.reset}: #{error}"
end

def ofail(error)
  onoe error
  Homebrew.failed = true
end

def odie(error)
  onoe error
  exit 1
end

def pretty_installed(f)
  if !$stdout.tty?
    "#{f}"
  elsif ENV["HOMEBREW_NO_EMOJI"]
    "#{Tty.highlight}#{Tty.green}#{f} (installed)#{Tty.reset}"
  else
    "#{Tty.highlight}#{f} #{Tty.green}#{Tty.tick}#{Tty.reset}"
  end
end

def pretty_uninstalled(f)
  if !$stdout.tty?
    "#{f}"
  elsif ENV["HOMEBREW_NO_EMOJI"]
    "#{Tty.red}#{f} (uninstalled)#{Tty.reset}"
  else
    "#{f} #{Tty.red}#{Tty.cross}#{Tty.reset}"
  end
end

def pretty_duration(s)
  s = s.to_i
  res = ""

  if s > 59
    m = s / 60
    s %= 60
    res = "#{m} minute#{plural m}"
    return res if s == 0
    res << " "
  end

  res + "#{s} second#{plural s}"
end

def plural(n, s = "s")
  (n == 1) ? "" : s
end

def interactive_shell(f = nil)
  unless f.nil?
    ENV["HOMEBREW_DEBUG_PREFIX"] = f.prefix
    ENV["HOMEBREW_DEBUG_INSTALL"] = f.full_name
  end

  if ENV["SHELL"].include?("zsh") && ENV["HOME"].start_with?(HOMEBREW_TEMP.resolved_path.to_s)
    FileUtils.touch "#{ENV["HOME"]}/.zshrc"
  end

  Process.wait fork { exec ENV["SHELL"] }

  if $?.success?
    return
  elsif $?.exited?
    puts "Aborting due to non-zero exit status"
    exit $?.exitstatus
  else
    raise $?.inspect
  end
end

module Homebrew
  def self._system(cmd, *args)
    pid = fork do
      yield if block_given?
      args.collect!(&:to_s)
      exec(cmd, *args) rescue nil
      exit! 1 # never gets here unless exec failed
    end
    Process.wait(pid)
    $?.success?
  end

  def self.system(cmd, *args)
    puts "#{cmd} #{args*" "}" if ARGV.verbose?
    _system(cmd, *args)
  end

  def self.git_origin
    return unless Utils.git_available?
    HOMEBREW_REPOSITORY.cd { `git config --get remote.origin.url 2>/dev/null`.chuzzle }
  end

  def self.git_head
    return unless Utils.git_available?
    HOMEBREW_REPOSITORY.cd { `git rev-parse --verify -q HEAD 2>/dev/null`.chuzzle }
  end

  def self.git_short_head
    return unless Utils.git_available?
    HOMEBREW_REPOSITORY.cd { `git rev-parse --short=4 --verify -q HEAD 2>/dev/null`.chuzzle }
  end

  def self.git_last_commit
    return unless Utils.git_available?
    HOMEBREW_REPOSITORY.cd { `git show -s --format="%cr" HEAD 2>/dev/null`.chuzzle }
  end

  def self.git_last_commit_date
    return unless Utils.git_available?
    HOMEBREW_REPOSITORY.cd { `git show -s --format="%cd" --date=short HEAD 2>/dev/null`.chuzzle }
  end

  def self.homebrew_version_string
    if pretty_revision = git_short_head
      last_commit = git_last_commit_date
      "#{HOMEBREW_VERSION} (git revision #{pretty_revision}; last commit #{last_commit})"
    else
      "#{HOMEBREW_VERSION} (no git repository)"
    end
  end

  def self.install_gem_setup_path!(gem, version = nil, executable = gem)
    require "rubygems"

    # Add Gem binary directory and (if missing) Ruby binary directory to PATH.
    path = ENV["PATH"].split(File::PATH_SEPARATOR)
    path.unshift(RUBY_BIN) if which("ruby") != RUBY_PATH
    path.unshift("#{Gem.user_dir}/bin")
    ENV["PATH"] = path.join(File::PATH_SEPARATOR)

    if Gem::Specification.find_all_by_name(gem, version).empty?
      ohai "Installing or updating '#{gem}' gem"
      install_args = %W[--no-ri --no-rdoc --user-install #{gem}]
      install_args << "--version" << version if version

      # Do `gem install [...]` without having to spawn a separate process or
      # having to find the right `gem` binary for the running Ruby interpreter.
      require "rubygems/commands/install_command"
      install_cmd = Gem::Commands::InstallCommand.new
      install_cmd.handle_options(install_args)
      exit_code = 1 # Should not matter as `install_cmd.execute` always throws.
      begin
        install_cmd.execute
      rescue Gem::SystemExitException => e
        exit_code = e.exit_code
      end
      odie "Failed to install/update the '#{gem}' gem." if exit_code != 0
    end

    unless which executable
      odie <<-EOS.undent
        The '#{gem}' gem is installed but couldn't find '#{executable}' in the PATH:
        #{ENV["PATH"]}
      EOS
    end
  end
end

def with_system_path
  old_path = ENV["PATH"]
  ENV["PATH"] = "/usr/bin:/bin"
  yield
ensure
  ENV["PATH"] = old_path
end

def run_as_not_developer(&_block)
  old = ENV.delete "HOMEBREW_DEVELOPER"
  yield
ensure
  ENV["HOMEBREW_DEVELOPER"] = old
end

# Kernel.system but with exceptions
def safe_system(cmd, *args)
  Homebrew.system(cmd, *args) || raise(ErrorDuringExecution.new(cmd, args))
end

# prints no output
def quiet_system(cmd, *args)
  Homebrew._system(cmd, *args) do
    # Redirect output streams to `/dev/null` instead of closing as some programs
    # will fail to execute if they can't write to an open stream.
    $stdout.reopen("/dev/null")
    $stderr.reopen("/dev/null")
  end
end

def curl(*args)
  brewed_curl = HOMEBREW_PREFIX/"opt/curl/bin/curl"
  curl = if MacOS.version <= "10.8" && brewed_curl.exist?
    brewed_curl
  else
    Pathname.new "/usr/bin/curl"
  end
  raise "#{curl} is not executable" unless curl.exist? && curl.executable?

  flags = HOMEBREW_CURL_ARGS
  flags = flags.delete("#") if ARGV.verbose?

  args = [flags, HOMEBREW_USER_AGENT, *args]
  args << "--verbose" if ENV["HOMEBREW_CURL_VERBOSE"]
  args << "--silent" if !$stdout.tty? || ENV["TRAVIS"]

  safe_system curl, *args
end

def puts_columns(items)
  return if items.empty?

  unless $stdout.tty?
    puts items
    return
  end

  # TTY case: If possible, output using multiple columns.
  console_width = Tty.width
  console_width = 80 if console_width <= 0
  plain_item_lengths = items.map { |s| Tty.strip_ansi(s).length }
  max_len = plain_item_lengths.max
  col_gap = 2 # number of spaces between columns
  gap_str = " " * col_gap
  cols = (console_width + col_gap) / (max_len + col_gap)
  cols = 1 if cols < 1
  rows = (items.size + cols - 1) / cols
  cols = (items.size + rows - 1) / rows # avoid empty trailing columns

  if cols >= 2
    col_width = (console_width + col_gap) / cols - col_gap
    items = items.each_with_index.map do |item, index|
      item + "".ljust(col_width - plain_item_lengths[index])
    end
  end

  if cols == 1
    puts items
  else
    rows.times do |row_index|
      item_indices_for_row = row_index.step(items.size - 1, rows).to_a
      puts items.values_at(*item_indices_for_row).join(gap_str)
    end
  end
end

def which(cmd, path = ENV["PATH"])
  path.split(File::PATH_SEPARATOR).each do |p|
    begin
      pcmd = File.expand_path(cmd, p)
    rescue ArgumentError
      # File.expand_path will raise an ArgumentError if the path is malformed.
      # See https://github.com/Homebrew/homebrew/issues/32789
      next
    end
    return Pathname.new(pcmd) if File.file?(pcmd) && File.executable?(pcmd)
  end
  nil
end

def which_all(cmd, path = ENV["PATH"])
  path.split(File::PATH_SEPARATOR).map do |p|
    begin
      pcmd = File.expand_path(cmd, p)
    rescue ArgumentError
      # File.expand_path will raise an ArgumentError if the path is malformed.
      # See https://github.com/Homebrew/homebrew/issues/32789
      next
    end
    Pathname.new(pcmd) if File.file?(pcmd) && File.executable?(pcmd)
  end.compact.uniq
end

def which_editor
  editor = ENV.values_at("HOMEBREW_EDITOR", "VISUAL", "EDITOR").compact.first
  return editor unless editor.nil?

  # Find Textmate
  editor = "mate" if which "mate"
  # Find BBEdit / TextWrangler
  editor ||= "edit" if which "edit"
  # Find vim
  editor ||= "vim" if which "vim"
  # Default to standard vim
  editor ||= "/usr/bin/vim"

  opoo <<-EOS.undent
    Using #{editor} because no editor was set in the environment.
    This may change in the future, so we recommend setting EDITOR, VISUAL,
    or HOMEBREW_EDITOR to your preferred text editor.
  EOS

  editor
end

def exec_editor(*args)
  safe_exec(which_editor, *args)
end

def exec_browser(*args)
  browser = ENV["HOMEBREW_BROWSER"] || ENV["BROWSER"] || OS::PATH_OPEN
  safe_exec(browser, *args)
end

def safe_exec(cmd, *args)
  # This buys us proper argument quoting and evaluation
  # of environment variables in the cmd parameter.
  exec "/bin/sh", "-c", "#{cmd} \"$@\"", "--", *args
end

# GZips the given paths, and returns the gzipped paths
def gzip(*paths)
  paths.collect do |path|
    with_system_path { safe_system "gzip", path }
    Pathname.new("#{path}.gz")
  end
end

# Returns array of architectures that the given command or library is built for.
def archs_for_command(cmd)
  cmd = which(cmd) unless Pathname.new(cmd).absolute?
  Pathname.new(cmd).archs
end

def ignore_interrupts(opt = nil)
  std_trap = trap("INT") do
    puts "One sec, just cleaning up" unless opt == :quietly
  end
  yield
ensure
  trap("INT", std_trap)
end

def nostdout
  if ARGV.verbose?
    yield
  else
    begin
      out = $stdout.dup
      $stdout.reopen("/dev/null")
      yield
    ensure
      $stdout.reopen(out)
      out.close
    end
  end
end

def paths
  @paths ||= ENV["PATH"].split(File::PATH_SEPARATOR).collect do |p|
    begin
      File.expand_path(p).chomp("/")
    rescue ArgumentError
      onoe "The following PATH component is invalid: #{p}"
    end
  end.uniq.compact
end

# return the shell profile file based on users' preference shell
def shell_profile
  case ENV["SHELL"]
  when %r{/(ba)?sh} then "~/.bash_profile"
  when %r{/zsh} then "~/.zshrc"
  when %r{/ksh} then "~/.kshrc"
  else "~/.bash_profile"
  end
end

module GitHub
  extend self
  ISSUES_URI = URI.parse("https://api.github.com/search/issues")

  Error = Class.new(RuntimeError)
  HTTPNotFoundError = Class.new(Error)

  class RateLimitExceededError < Error
    def initialize(reset, error)
      super <<-EOS.undent
        GitHub #{error}
        Try again in #{pretty_ratelimit_reset(reset)}, or create a personal access token:
          #{Tty.em}https://github.com/settings/tokens/new?scopes=&description=Homebrew#{Tty.reset}
        and then set the token as: HOMEBREW_GITHUB_API_TOKEN
      EOS
    end

    def pretty_ratelimit_reset(reset)
      pretty_duration(Time.at(reset) - Time.now)
    end
  end

  class AuthenticationFailedError < Error
    def initialize(error)
      super <<-EOS.undent
        GitHub #{error}
        HOMEBREW_GITHUB_API_TOKEN may be invalid or expired, check:
          #{Tty.em}https://github.com/settings/tokens#{Tty.reset}
      EOS
    end
  end

  def api_credentials
    @api_credentials ||= begin
      if ENV["HOMEBREW_GITHUB_API_TOKEN"]
        ENV["HOMEBREW_GITHUB_API_TOKEN"]
      else
        github_credentials = IO.popen("git credential-osxkeychain get", "w+") do |io|
          io.puts "protocol=https\nhost=github.com"
          io.close_write
          io.read
        end
        github_username = github_credentials[/username=(.+)/, 1]
        github_password = github_credentials[/password=(.+)/, 1]
        [github_password, github_username] if github_username && github_password
      end
    end
  end

  def api_headers
    @api_headers ||= begin
        headers = {
        "User-Agent" => HOMEBREW_USER_AGENT,
        "Accept"     => "application/vnd.github.v3+json"
      }
      token, username = api_credentials
      if token && !token.empty?
        if username && !username.empty?
          headers[:http_basic_authentication] = [username, token]
        else
          headers["Authorization"] = "token #{token}"
        end
      end
      headers
    end
  end

  def open(url, &_block)
    # This is a no-op if the user is opting out of using the GitHub API.
    return if ENV["HOMEBREW_NO_GITHUB_API"]

    require "net/https"

    begin
      Kernel.open(url, api_headers) { |f| yield Utils::JSON.load(f.read) }
    rescue OpenURI::HTTPError => e
      handle_api_error(e)
    rescue EOFError, SocketError, OpenSSL::SSL::SSLError => e
      raise Error, "Failed to connect to: #{url}\n#{e.message}", e.backtrace
    rescue Utils::JSON::Error => e
      raise Error, "Failed to parse JSON response\n#{e.message}", e.backtrace
    end
  end

  def handle_api_error(e)
    if e.io.meta.fetch("x-ratelimit-remaining", 1).to_i <= 0
      reset = e.io.meta.fetch("x-ratelimit-reset").to_i
      error = Utils::JSON.load(e.io.read)["message"]
      raise RateLimitExceededError.new(reset, error)
    end

    case e.io.status.first
    when "401", "403"
      raise AuthenticationFailedError.new(e.message)
    when "404"
      raise HTTPNotFoundError, e.message, e.backtrace
    else
      error = Utils::JSON.load(e.io.read)["message"] rescue nil
      raise Error, [e.message, error].compact.join("\n"), e.backtrace
    end
  end

  def issues_matching(query, qualifiers = {})
    uri = ISSUES_URI.dup
    uri.query = build_query_string(query, qualifiers)
    open(uri) { |json| json["items"] }
  end

  def repository(user, repo)
    open(URI.parse("https://api.github.com/repos/#{user}/#{repo}")) { |j| j }
  end

  def build_query_string(query, qualifiers)
    s = "q=#{uri_escape(query)}+"
    s << build_search_qualifier_string(qualifiers)
    s << "&per_page=100"
  end

  def build_search_qualifier_string(qualifiers)
    {
      :repo => "Homebrew/homebrew",
      :in => "title"
    }.update(qualifiers).map do |qualifier, value|
      "#{qualifier}:#{value}"
    end.join("+")
  end

  def uri_escape(query)
    if URI.respond_to?(:encode_www_form_component)
      URI.encode_www_form_component(query)
    else
      require "erb"
      ERB::Util.url_encode(query)
    end
  end

  def issues_for_formula(name)
    issues_matching(name, :state => "open")
  end

  def print_pull_requests_matching(query)
    return [] if ENV["HOMEBREW_NO_GITHUB_API"]
    ohai "Searching pull requests..."

    open_or_closed_prs = issues_matching(query, :type => "pr")

    open_prs = open_or_closed_prs.select { |i| i["state"] == "open" }
    if open_prs.any?
      puts "Open pull requests:"
      prs = open_prs
    elsif open_or_closed_prs.any?
      puts "Closed pull requests:"
      prs = open_or_closed_prs
    else
      return
    end

    prs.each { |i| puts "#{i["title"]} (#{i["html_url"]})" }
  end

  def private_repo?(user, repo)
    uri = URI.parse("https://api.github.com/repos/#{user}/#{repo}")
    open(uri) { |json| json["private"] }
  end
end

def disk_usage_readable(size_in_bytes)
  if size_in_bytes >= 1_073_741_824
    size = size_in_bytes.to_f / 1_073_741_824
    unit = "G"
  elsif size_in_bytes >= 1_048_576
    size = size_in_bytes.to_f / 1_048_576
    unit = "M"
  elsif size_in_bytes >= 1_024
    size = size_in_bytes.to_f / 1_024
    unit = "K"
  else
    size = size_in_bytes
    unit = "B"
  end

  # avoid trailing zero after decimal point
  if (size * 10).to_i % 10 == 0
    "#{size.to_i}#{unit}"
  else
    "#{"%.1f" % size}#{unit}"
  end
end

def number_readable(number)
  numstr = number.to_i.to_s
  (numstr.size - 3).step(1, -3) { |i| numstr.insert(i, ",") }
  numstr
end
