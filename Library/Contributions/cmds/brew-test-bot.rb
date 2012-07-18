# Comprehensively test a formula or pull request.
#
# Usage: brew test-bot [options...] <pull-request|formula>
#
# Options:
# --log:     Writes log files under ./brewbot/
# --html:    Writes html and log files under ./brewbot/
# --comment: Comment on the pull request
# --clean:   Clean the Homebrew directory. Very dangerous. Use with care.

require 'utils'
require 'date'

HOMEBREW_CONTRIBUTED_CMDS = HOMEBREW_REPOSITORY + "Library/Contributions/cmds/"

class Step
  attr_reader :command
  attr_accessor :status

  def initialize test, command
    @test = test
    @category = test.category
    @command = command
    @name = command.split[1].delete '-'
    @status = :running
    @test.steps << self
    write_html
  end

  def log_file_path full_path=true
    return "/dev/null" unless ARGV.include? "--log" or ARGV.include? "--html"
    file = "#{@category}.#{@name}.txt"
    return file unless @test.log_root and full_path
    @test.log_root + file
  end

  def status_colour
    case @status
    when :passed  then "green"
    when :running then "orange"
    when :failed  then "red"
    end
  end

  def status_upcase
    @status.to_s.upcase
  end

  def puts_command
    print "#{Tty.blue}==>#{Tty.white} #{@command}#{Tty.reset}"
    tabs = (80 - "PASSED".length + 1 - @command.length) / 8
    tabs.times{ print "\t" }
    $stdout.flush
  end

  def puts_result
    puts "#{Tty.send status_colour}#{status_upcase}#{Tty.reset}"
  end

  def write_html
    return unless @test.log_root and ARGV.include? "--html"

    open(@test.log_root + "index.html", "w") do |index|
      commit_html, css = @test.commit_html_and_css
      index.write commit_html.result binding
    end
  end

  def self.run test, command
    step = new test, command
    step.puts_command
    `#{step.command} &>#{step.log_file_path}`
    step.status = $?.success? ? :passed : :failed
    step.puts_result
    step.write_html
  end
end

class Test
  attr_reader :log_root, :category, :name
  attr_reader :core_changed, :formulae
  attr_accessor :steps

  @@css = @@index_html = @@commit_html = nil

  def commit_html_and_css
    return @@commit_html, @@css
  end

  def initialize arg
    begin
      Formula.factory arg
    rescue FormulaUnavailableError
      odie "#{arg} is not a pull request number or formula." unless arg.to_i > 0
      @url = arg
      @formulae = []
    else
      @url = nil
      @formulae = [arg]
    end

    @start_sha1 = nil
    @category = __method__
    @steps = []
    @core_changed = false
    @brewbot_root = Pathname.pwd + "brewbot"
    FileUtils.mkdir_p @brewbot_root if ARGV.include? "--log" or ARGV.include? "--html"

    if ARGV.include? "--html" and not @@css
      require 'erb'
      root = HOMEBREW_CONTRIBUTED_CMDS/"brew-test-bot"
      @@css = IO.read root + "brew-test-bot.css"
      @@index_html = ERB.new IO.read root + "brew-test-bot.index.html.erb"
      @@commit_html = ERB.new IO.read root + "brew-test-bot.commit.html.erb"
    end
  end

  def write_root_html status
    return unless ARGV.include? "--html"

    FileUtils.mv Dir.glob("*.txt"), @log_root
    open(@log_root + "status.txt", "w") do |file|
      file.write status
    end

    dirs = []
    dates = []
    statuses = []

    Pathname.glob("#{@brewbot_root}/*/status.txt").each do |result|
       dirs << result.dirname.basename
       status_file = result.dirname + "status.txt"
       dates << File.mtime(status_file).strftime("%T %D")
       statuses << IO.read(status_file)
    end

    open(@brewbot_root + "index.html", "w") do |index|
      css = @@css
      index.write @@index_html.result binding
    end
  end

  def download
    def current_sha1
      `git rev-parse --short HEAD`.strip
    end

    def current_branch
      `git symbolic-ref HEAD`.slice!("refs/heads/").strip
    end

    @category = __method__
    if @url
      `git am --abort 2>/dev/null`
      test "brew update" if current_branch == "master"
      @start_sha1 = current_sha1
      test "brew pull --clean #{@url}"
      end_sha1 = current_sha1
    else
      @start_sha1 = end_sha1 = current_sha1
    end

    name_prefix = @url ? @url : @formulae.first
    @name = "#{name_prefix}-#{end_sha1}"
    @log_root = @brewbot_root + @name
    FileUtils.mkdir_p @log_root if ARGV.include? "--log" or ARGV.include? "--html"

    write_root_html :running

    return unless @url and @start_sha1 != end_sha1 and steps.last.status == :passed

    `git diff #{@start_sha1}..#{end_sha1} --name-status`.each_line do |line|
      status, filename = line.split
      # Don't try and do anything to removed files.
      if (status == 'A' or status == 'M')
        if filename.include? '/Formula/'
          @formulae << File.basename(filename, '.rb')
        end
      end
      if filename.include? '/Homebrew/' or filename.include? 'bin/brew'
        @homebrew_changed = true
      end
    end
  end

  def setup
    @category = __method__

    test "brew doctor"
    test "brew --env"
    test "brew --config"
  end

  def formula formula
    @category = __method__.to_s + ".#{formula}"

    test "brew audit #{formula}"
    test "brew install --verbose --build-bottle #{formula}"
    return unless steps.last.status == :passed
    test "brew test #{formula}"
    test "brew bottle #{formula}"
    test "brew uninstall #{formula}"
  end

  def homebrew
    @category = __method__
    test "brew tests"
  end

  def cleanup
    @category = __method__
    if ARGV.include? "--clean"
      test "git reset --hard origin/master"
      test "git clean --force -dx"
    else
      `git diff --exit-code HEAD 2>/dev/null`
      odie "Uncommitted changes, aborting." unless $?.success?
      test "git reset --hard #{@start_sha1}" if @start_sha1
    end
  end

  def test cmd
    Step.run self, cmd
  end

  def check_results
    message = "All tests passed and raring to brew."

    status = :passed
    steps.each do |step|
      case step.status
      when :passed  then next
      when :running then raise
      when :failed  then
        if status == :passed
          status = :failed
          message = ""
        end
        message += "#{step.command}: #{step.status.to_s.upcase}\n"
      end
    end

    write_root_html status

    if ARGV.include? "--comment" and @url
      username, password = IO.read(File.expand_path('~/.brewbot')).split(':')
      url = "https://api.github.com/repos/mxcl/homebrew/issues/#{@url}/comments"
      require 'vendor/multi_json'
      json = MultiJson.encode(:body => message)
      curl url, "-X", "POST",  "--user", "#{username}:#{password}", "--data", json, "-o", "/dev/null"
    end
  end

  def self.run url
    test = new url
    test.cleanup
    test.download
    test.setup
    test.formulae.each do |f|
      test.formula f
    end
    test.homebrew if test.core_changed
    test.cleanup

    test.check_results
  end
end

if ARGV.empty?
  odie 'This command requires at least one argument containing a pull request number or formula.'
end

Dir.chdir HOMEBREW_REPOSITORY

ARGV.named.each do|arg|
  Test.run arg
end
