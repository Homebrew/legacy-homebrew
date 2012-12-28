# Comprehensively test a formula or pull request.
#
# Usage: brew test-bot [options...] <pull-request|formula>
#
# Options:
# --keep-logs:    Write and keep log files under ./brewbot/
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
  end

  def log_file_path full_path=true
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

  def self.run test, command, puts_output_on_success = false
    step = new test, command
    step.puts_command

    command = "#{step.command} &>#{step.log_file_path}"

    output = nil
    if command.start_with? 'git '
      Dir.chdir step.repository do
        output = `#{command}`
      end
    else
      output = `#{command}`
    end
    output = IO.read(step.log_file_path)

    success = $?.success?
    step.status = success ? :passed : :failed
    step.puts_result
    if output and output.any? and (not success or puts_output_on_success)
      puts output
    end
    FileUtils.rm step.log_file_path unless ARGV.include? "--keep-logs"
  end
end

class Test
  attr_reader :log_root, :category, :name
  attr_reader :core_changed, :formulae
  attr_accessor :steps

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
    FileUtils.mkdir_p @brewbot_root
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
    FileUtils.mkdir_p @log_root

    return unless diff_start_sha1 != diff_end_sha1
    return if @url and steps.last.status != :passed

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

    dependencies = `brew deps #{formula}`.split("\n")
    dependencies -= `brew list`.split("\n")
    dependencies = dependencies.join(' ')
    formula_object = Formula.factory(formula)

    test "brew audit #{formula}"
    test "brew fetch #{dependencies}" unless dependencies.empty?
    test "brew fetch --build-bottle #{formula}"
    test "brew install --verbose #{dependencies}" unless dependencies.empty?
    test "brew install --verbose --build-bottle #{formula}"
    return unless steps.last.status == :passed
    test "brew bottle #{formula}", true
    bottle_version = bottle_new_version(formula_object)
    bottle_filename = bottle_filename(formula_object, bottle_version)
    test "brew uninstall #{formula}"
    test "brew install #{bottle_filename}"
    test "brew test #{formula}" if defined? formula_object.test
    test "brew uninstall #{formula}"
    test "brew uninstall #{dependencies}" unless dependencies.empty?
  end

  def homebrew
    @category = __method__
    test "brew tests"
    test "brew readall"
  end

  def cleanup_before
    @category = __method__
    return unless ARGV.include? '--cleanup'
    git 'stash --all'
    git 'am --abort 2>/dev/null'
    git 'rebase --abort 2>/dev/null'
    git 'reset --hard'
    git 'clean --force -dx'
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
      test 'git gc'
      git 'stash pop 2>/dev/null'
    end

    FileUtils.rm_rf @brewbot_root unless ARGV.include? "--keep-logs"
  end

  def test cmd, puts_output_on_success = false
    Step.run self, cmd, puts_output_on_success
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
    status == :passed
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

any_errors = false
if ARGV.named.empty?
  # With no arguments just build the most recent commit.
  any_errors = Test.run 'HEAD'
else
  ARGV.named.each { |argument| any_errors = Test.run(argument) or any_errors }
end
exit any_errors ? 0 : 1
