# Comprehensively test a formula or pull request.
#
# Usage: brew test-bot [options...] <pull-request|formula>
#
# Options:
# --log:          Writes log files under ./brewbot/
# --html:         Writes html and log files under ./brewbot/
# --comment:      Comment on the pull request
# --cleanup:      Clean the Homebrew directory. Very dangerous. Use with care.
# --skip-setup:   Don't check the local system is setup correctly.

require 'formula'
require 'utils'
require 'date'

HOMEBREW_CONTRIBUTED_CMDS = HOMEBREW_REPOSITORY + "Library/Contributions/cmds/"

class Step
  attr_reader :command, :repository
  attr_accessor :status

  def initialize test, command
    @test = test
    @category = test.category
    @command = command
    @name = command.split[1].delete '-'
    @status = :running
    @repository = HOMEBREW_REPOSITORY
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

  def self.run test, command, puts_output = false
    step = new test, command
    step.puts_command

    command = "#{step.command}"
    unless puts_output and not ARGV.include? "--log"
      command += " &>#{step.log_file_path}"
    end

    output = nil
    if command.start_with? 'git '
      Dir.chdir step.repository do
        output = `#{command}`
      end
    else
      output = `#{command}`
    end
    output = IO.read(step.log_file_path) if ARGV.include? "--log"

    step.status = $?.success? ? :passed : :failed
    step.puts_result
    step.write_html
    puts output if puts_output and output and not output.empty?
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

  def initialize argument
    @hash = nil
    @url = nil
    @formulae = []

    url_match = argument.match HOMEBREW_PULL_URL_REGEX
    formula = Formula.factory argument rescue FormulaUnavailableError
    git "rev-parse --verify #{argument} &>/dev/null"
    if $?.success?
      @hash = argument
    elsif url_match
      @url = url_match[0]
    elsif formula
      @formulae = [argument]
    else
      odie "#{argument} is not a pull request URL, commit URL or formula name."
    end

    @category = __method__
    @steps = []
    @core_changed = false
    @brewbot_root = Pathname.pwd + "brewbot"
    if ARGV.include? "--log" or ARGV.include? "--html"
      FileUtils.mkdir_p @brewbot_root
    end

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

  def git arguments
    Dir.chdir HOMEBREW_REPOSITORY do
      `git #{arguments}`
    end
  end

  def download
    def current_sha1
      git('rev-parse --short HEAD').strip
    end

    def current_branch
      git('symbolic-ref HEAD').gsub('refs/heads/', '').strip
    end

    @category = __method__
    @start_branch = current_branch

    if @hash or @url
      diff_start_sha1 = current_sha1
      test "brew update" if current_branch == "master"
      diff_end_sha1 = current_sha1
    end

    if @hash == 'HEAD'
      @name = "#{diff_start_sha1}-#{diff_end_sha1}"
    elsif @hash
      test "git checkout #{@hash}"
      diff_start_sha1 = "#{@hash}^"
      diff_end_sha1 = @hash
      @name = @hash
    elsif @url
      test "git checkout #{current_sha1}"
      test "brew pull --clean #{@url}"
      diff_end_sha1 = current_sha1
      @name = "#{@url}-#{diff_end_sha1}"
    else
      diff_start_sha1 = diff_end_sha1 = current_sha1
      @name = "#{@formulae.first}-#{diff_end_sha1}"
    end

    @log_root = @brewbot_root + @name
    if ARGV.include? "--log" or ARGV.include? "--html"
      FileUtils.mkdir_p @log_root
    end

    return unless diff_start_sha1 != diff_end_sha1
    return if @url and steps.last.status != :passed

    write_root_html :running

    diff_stat = git "diff #{diff_start_sha1}..#{diff_end_sha1} --name-status"
    diff_stat.each_line do |line|
      status, filename = line.split
      # Don't try and do anything to removed files.
      if (status == 'A' or status == 'M')
        if filename.include? '/Formula/'
          @formulae << File.basename(filename, '.rb')
        end
      end
      if filename.include? '/Homebrew/' or filename.include? '/ENV/' \
        or filename.include? 'bin/brew'
        @core_changed = true
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
    test "brew fetch --deps #{formula}"
    test "brew install --verbose --build-bottle #{formula}"
    return unless steps.last.status == :passed
    test "brew bottle #{formula}", true
    test "brew test #{formula}" if defined? Formula.factory(formula).test
    test "brew uninstall #{formula}"
  end

  def homebrew
    @category = __method__
    test "brew tests"
    test "brew readall"
  end

  def cleanup_before
    @category = __method__
    return unless ARGV.include? '--cleanup'
    test 'git stash --include-untracked'
    git 'am --abort 2>/dev/null'
    git 'rebase --abort 2>/dev/null'
    test 'git reset --hard'
    test 'git clean --force -dx'
  end

  def cleanup_after
    @category = __method__
    force_flag = ''
    if ARGV.include? '--cleanup'
      test 'brew cleanup'
      test 'git clean --force -dx'
      force_flag = '-f'
    end

    if ARGV.include? '--cleanup' or @url or @hash
      test "git checkout #{force_flag} #{@start_branch}"
    end

    if ARGV.include? '--cleanup'
      test 'git reset --hard'
      test 'git stash pop'
      test 'git gc'
    end
  end

  def test cmd, puts_output = false
    Step.run self, cmd, puts_output
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
      curl url, "-X", "POST",  "--user", "#{username}:#{password}", \
        "--data", json, "-o", "/dev/null"
    end
  end

  def self.run argument
    test = new argument
    test.cleanup_before
    test.download
    test.setup unless ARGV.include? "--skip-setup"
    test.formulae.each do |formula|
      test.formula formula
    end
    test.homebrew if test.core_changed
    test.cleanup_after
    test.check_results
  end
end

if Pathname.pwd == HOMEBREW_PREFIX and ARGV.include? "--cleanup"
  odie 'cannot use --cleanup from HOMEBREW_PREFIX as it will delete all output.'
end

if ARGV.named.empty?
  # With no arguments just build the most recent commit.
  Test.run 'HEAD'
else
  ARGV.named.each { |argument| Test.run argument }
end
