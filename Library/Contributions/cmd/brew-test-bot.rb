# Comprehensively test a formula or pull request.
#
# Usage: brew test-bot [options...] <pull-request|formula>
#
# Options:
# --keep-logs:    Write and keep log files under ./brewbot/
# --cleanup:      Clean the Homebrew directory. Very dangerous. Use with care.
# --clean-cache:  Remove all cached downloads. Use with care.
# --skip-setup:   Don't check the local system is setup correctly.
# --junit:        Generate a JUnit XML test results file.
# --email:        Generate an email subject file.
# --no-bottle:    Run brew install without --build-bottle
# --HEAD:         Run brew install with --HEAD
# --local:        Ask Homebrew to write verbose logs under ./logs/
#
# --ci-master:         Shortcut for Homebrew master branch CI options.
# --ci-pr:             Shortcut for Homebrew pull request CI options.
# --ci-testing:        Shortcut for Homebrew testing CI options.
# --ci-pr-upload:      Homebrew CI pull request bottle upload.
# --ci-testing-upload: Homebrew CI testing bottle upload.

require 'formula'
require 'utils'
require 'date'
require 'rexml/document'
require 'rexml/xmldecl'
require 'rexml/cdata'

EMAIL_SUBJECT_FILE = "brew-test-bot.#{MacOS.cat}.email.txt"

class Step
  attr_reader :command, :name, :status, :output, :time

  def initialize test, command, options={}
    @test = test
    @category = test.category
    @command = command
    @puts_output_on_success = options[:puts_output_on_success]
    @name = command.split[1].delete '-'
    @status = :running
    @repository = HOMEBREW_REPOSITORY
    @time = 0
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

  def command_short
    @command.gsub(/(brew|--force|--retry|--verbose|--build-bottle|--rb) /, '').strip.squeeze ' '
  end

  def passed?
    @status == :passed
  end

  def failed?
    @status == :failed
  end

  def puts_command
    print "#{Tty.blue}==>#{Tty.white} #{@command}#{Tty.reset}"
    tabs = (80 - "PASSED".length + 1 - @command.length) / 8
    tabs.times{ print "\t" }
    $stdout.flush
  end

  def puts_result
    puts " #{Tty.send status_colour}#{status_upcase}#{Tty.reset}"
  end

  def has_output?
    @output and @output.any?
  end

  def run
    puts_command

    start_time = Time.now
    run_command = "#{@command} &>'#{log_file_path}'"
    if run_command.start_with? 'git '
      Dir.chdir @repository do
        `#{run_command}`
      end
    else
      `#{run_command}`
    end
    end_time = Time.now
    @time = end_time - start_time

    success = $?.success?
    @status = success ? :passed : :failed
    puts_result

    return unless File.exist?(log_file_path)
    @output = IO.read(log_file_path)
    if has_output? and (not success or @puts_output_on_success)
      puts @output
    end
    FileUtils.rm log_file_path unless ARGV.include? "--keep-logs"
  end
end

class Test
  attr_reader :log_root, :category, :name, :formulae, :steps

  def initialize argument
    @hash = nil
    @url = nil
    @formulae = []

    url_match = argument.match HOMEBREW_PULL_OR_COMMIT_URL_REGEX
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
    @brewbot_root = Pathname.pwd + "brewbot"
    FileUtils.mkdir_p @brewbot_root
  end

  def no_args?
    @hash == 'HEAD'
  end

  def git arguments
    Dir.chdir HOMEBREW_REPOSITORY do
      `git #{arguments}`
    end
  end

  def download
    def shorten_revision revision
      git("rev-parse --short #{revision}").strip
    end

    def current_sha1
      shorten_revision 'HEAD'
    end

    def current_branch
      git('symbolic-ref HEAD').gsub('refs/heads/', '').strip
    end

    def single_commit? start_revision, end_revision
      git("rev-list --count #{start_revision}..#{end_revision}").to_i == 1
    end

    @category = __method__
    @start_branch = current_branch

    # Use Jenkins environment variables if present.
    if no_args? and ENV['GIT_PREVIOUS_COMMIT'] and ENV['GIT_COMMIT'] \
       and not ENV['ghprbPullId']
      diff_start_sha1 = shorten_revision ENV['GIT_PREVIOUS_COMMIT']
      diff_end_sha1 = shorten_revision ENV['GIT_COMMIT']
      test "brew update" if current_branch == "master"
    elsif @hash or @url
      diff_start_sha1 = current_sha1
      test "brew update" if current_branch == "master"
      diff_end_sha1 = current_sha1
    end

    # Handle Jenkins pull request builder plugin.
    if ENV['ghprbPullId'] and ENV['GIT_URL']
      git_url = ENV['GIT_URL']
      git_match = git_url.match %r{.*github.com[:/](\w+/\w+).*}
      if git_match
        github_repo = git_match[1]
        pull_id = ENV['ghprbPullId']
        @url = "https://github.com/#{github_repo}/pull/#{pull_id}"
        @hash = nil
      else
        puts "Invalid 'ghprbPullId' environment variable value!"
      end
    end

    if no_args?
      if diff_start_sha1 == diff_end_sha1 or \
        single_commit?(diff_start_sha1, diff_end_sha1)
        @name = diff_end_sha1
      else
        @name = "#{diff_start_sha1}-#{diff_end_sha1}"
      end
    elsif @hash
      test "git checkout #{@hash}"
      diff_start_sha1 = "#{@hash}^"
      diff_end_sha1 = @hash
      @name = @hash
    elsif @url
      test "git checkout #{current_sha1}"
      test "brew pull --clean #{@url}"
      diff_end_sha1 = current_sha1
      @short_url = @url.gsub('https://github.com/', '')
      if @short_url.include? '/commit/'
        # 7 characters should be enough for a commit (not 40).
        @short_url.gsub!(/(commit\/\w{7}).*/, '\1')
        @name = @short_url
      else
        @name = "#{@short_url}-#{diff_end_sha1}"
      end
    else
      diff_start_sha1 = diff_end_sha1 = current_sha1
      @name = "#{@formulae.first}-#{diff_end_sha1}"
    end

    @log_root = @brewbot_root + @name
    FileUtils.mkdir_p @log_root

    return unless diff_start_sha1 != diff_end_sha1
    return if @url and not steps.last.passed?

    diff_stat = git "diff #{diff_start_sha1}..#{diff_end_sha1} --name-status"
    diff_stat.each_line do |line|
      status, filename = line.split
      # Don't try and do anything to removed files.
      if (status == 'A' or status == 'M')
        if filename.match /Formula\/.+\.rb$/
          @formulae << File.basename(filename, '.rb')
        end
      end
    end
  end

  def skip formula
    puts "#{Tty.blue}==>#{Tty.white} SKIPPING: #{formula}#{Tty.reset}"
  end

  def setup
    @category = __method__
    return if ARGV.include? "--skip-setup"
    test "brew doctor"
    test "brew --env"
    test "brew --config"
  end

  def formula formula
    @category = __method__.to_s + ".#{formula}"

    test "brew uses #{formula}"
    dependencies = `brew deps #{formula}`.split("\n")
    dependencies -= `brew list`.split("\n")
    dependencies = dependencies.join(' ')
    formula_object = Formula.factory(formula)
    requirements = formula_object.recursive_requirements
    unsatisfied_requirements = requirements.reject {|r| r.satisfied? or r.default_formula?}
    unless unsatisfied_requirements.empty?
      skip formula
      unsatisfied_requirements.each {|r| puts r.message}
      return
    end

    installed_gcc = false
    begin
      CompilerSelector.new(formula_object).compiler
    rescue CompilerSelectionError => e
      unless installed_gcc
        test "brew install gcc"
        installed_gcc = true
        retry
      end
      skip formula
      puts e.message
      return
    end

    test "brew fetch --retry #{dependencies}" unless dependencies.empty?
    formula_fetch_options = " "
    formula_fetch_options << " --build-bottle" unless ARGV.include? '--no-bottle'
    formula_fetch_options << " --force" if ARGV.include? '--cleanup'
    test "brew fetch --retry#{formula_fetch_options} #{formula}"
    test "brew uninstall --force #{formula}" if formula_object.installed?
    install_args = '--verbose'
    install_args << ' --build-bottle' unless ARGV.include? '--no-bottle'
    install_args << ' --HEAD' if ARGV.include? '--HEAD'
    test "brew install --only-dependencies #{install_args} #{formula}" unless dependencies.empty?
    test "brew install #{install_args} #{formula}"
    install_passed = steps.last.passed?
    test "brew audit #{formula}"
    if install_passed
      unless ARGV.include? '--no-bottle'
        test "brew bottle --rb #{formula}", :puts_output_on_success => true
        bottle_step = steps.last
        if bottle_step.passed? and bottle_step.has_output?
          bottle_filename =
            bottle_step.output.gsub(/.*(\.\/\S+#{bottle_native_regex}).*/m, '\1')
          test "brew uninstall --force #{formula}"
          test "brew install #{bottle_filename}"
        end
      end
      test "brew test --verbose #{formula}" if formula_object.test_defined?
      test "brew uninstall --force #{formula}"
    end
    if formula_object.devel and not ARGV.include? '--HEAD'
      test "brew fetch --retry --devel#{formula_fetch_options} #{formula}"
      test "brew install --devel --verbose #{formula}"
      devel_install_passed = steps.last.passed?
      test "brew audit --devel #{formula}"
      if devel_install_passed
        test "brew test --devel --verbose #{formula}" if formula_object.test_defined?
        test "brew uninstall --devel --force #{formula}"
      end
    end
    test "brew uninstall --force #{dependencies}" unless dependencies.empty?
  end

  def homebrew
    @category = __method__
    test "brew tests"
    test "brew readall"
  end

  def cleanup_before
    @category = __method__
    return unless ARGV.include? '--cleanup'
    git 'stash'
    git 'am --abort 2>/dev/null'
    git 'rebase --abort 2>/dev/null'
    git 'reset --hard'
    git 'checkout -f master 2>/dev/null'
    git 'clean --force -dx'
  end

  def cleanup_after
    @category = __method__
    force_flag = ''
    if ARGV.include? '--cleanup'
      test 'git clean --force -dx'
      force_flag = '-f'
    end

    if ARGV.include? '--cleanup' or @url or @hash
      test "git checkout #{force_flag} #{@start_branch}"
    end

    if ARGV.include? '--cleanup'
      test 'git reset --hard'
      git 'stash pop 2>/dev/null'
      test 'brew cleanup'
    end

    FileUtils.rm_rf @brewbot_root unless ARGV.include? "--keep-logs"
  end

  def test cmd, options={}
    step = Step.new self, cmd, options
    step.run
    steps << step
    step
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

  def run
    cleanup_before
    download
    setup
    homebrew
    formulae.each do |f|
      formula(f)
    end
    cleanup_after
    check_results
  end
end

if Pathname.pwd == HOMEBREW_PREFIX and ARGV.include? "--cleanup"
  odie 'cannot use --cleanup from HOMEBREW_PREFIX as it will delete all output.'
end

if ARGV.include? "--email"
  File.open EMAIL_SUBJECT_FILE, 'w' do |file|
    # The file should be written at the end but in case we don't get to that
    # point ensure that we have something valid.
    file.write "#{MacOS.version}: internal error."
  end
end

ENV['HOMEBREW_DEVELOPER'] = '1'
ENV['HOMEBREW_NO_EMOJI'] = '1'
if ARGV.include? '--ci-master' or ARGV.include? '--ci-pr' \
   or ARGV.include? '--ci-testing'
  ARGV << '--cleanup' << '--junit' << '--local'
end
if ARGV.include? '--ci-master'
  ARGV << '--no-bottle' << '--email'
end

if ARGV.include? '--local'
  ENV['HOMEBREW_LOGS'] = "#{Dir.pwd}/logs"
end

if ARGV.include? '--ci-pr-upload' or ARGV.include? '--ci-testing-upload'
  jenkins = ENV['JENKINS_HOME']
  job = ENV['UPSTREAM_JOB_NAME']
  id = ENV['UPSTREAM_BUILD_ID']
  raise "Missing Jenkins variables!" unless jenkins and job and id

  ARGV << '--verbose'
  copied = system "cp #{jenkins}/jobs/\"#{job}\"/configurations/axis-version/*/builds/#{id}/archive/*.bottle*.* ."
  exit unless copied

  ENV["GIT_COMMITTER_NAME"] = "BrewTestBot"
  ENV["GIT_COMMITTER_EMAIL"] = "brew-test-bot@googlegroups.com"

  pr = ENV['UPSTREAM_PULL_REQUEST']
  number = ENV['UPSTREAM_BUILD_NUMBER']

  system "git am --abort 2>/dev/null"
  system "git rebase --abort 2>/dev/null"
  safe_system "git checkout -f master"
  safe_system "git reset --hard origin/master"
  safe_system "brew update"

  if ARGV.include? '--ci-pr-upload'
    safe_system "brew pull --clean #{pr}"
  end

  ENV["GIT_AUTHOR_NAME"] = ENV["GIT_COMMITTER_NAME"]
  ENV["GIT_AUTHOR_EMAIL"] = ENV["GIT_COMMITTER_EMAIL"]
  safe_system "brew bottle --merge --write *.bottle*.rb"

  remote = "git@github.com:BrewTestBot/homebrew.git"
  tag = pr ? "pr-#{pr}" : "testing-#{number}"
  safe_system "git push --force #{remote} master:master :refs/tags/#{tag}"

  path = "/home/frs/project/m/ma/machomebrew/Bottles/"
  url = "BrewTestBot,machomebrew@frs.sourceforge.net:#{path}"
  options = "--partial --progress --human-readable --compress"
  safe_system "rsync #{options} *.bottle*.tar.gz #{url}"
  safe_system "git tag --force #{tag}"
  safe_system "git push --force #{remote} refs/tags/#{tag}"
  exit
end

tests = []
any_errors = false
if ARGV.named.empty?
  # With no arguments just build the most recent commit.
  test = Test.new('HEAD')
  any_errors = test.run
  tests << test
else
  ARGV.named.each do |argument|
    test = Test.new(argument)
    any_errors = test.run or any_errors
    tests << test
  end
end

if ARGV.include? "--junit"
  xml_document = REXML::Document.new
  xml_document << REXML::XMLDecl.new
  testsuites = xml_document.add_element 'testsuites'
  tests.each do |test|
    testsuite = testsuites.add_element 'testsuite'
    testsuite.attributes['name'] = "brew-test-bot.#{MacOS.cat}"
    testsuite.attributes['tests'] = test.steps.count
    test.steps.each do |step|
      testcase = testsuite.add_element 'testcase'
      testcase.attributes['name'] = step.command_short
      testcase.attributes['status'] = step.status
      testcase.attributes['time'] = step.time
      failure = testcase.add_element 'failure' if step.failed?
      if step.has_output?
        # Remove invalid XML CData characters from step output.
        output = REXML::CData.new step.output.delete("\000\b\e\f")
        if step.passed?
          system_out = testcase.add_element 'system-out'
          system_out.text = output
        else
          failure.attributes['message'] = "#{step.status}: #{step.command}"
          failure.text = output
        end
      end
    end
  end

  open("brew-test-bot.xml", "w") do |xml_file|
    pretty_print_indent = 2
    xml_document.write(xml_file, pretty_print_indent)
  end
end

if ARGV.include? "--email"
  failed_steps = []
  tests.each do |test|
    test.steps.each do |step|
      next unless step.failed?
      failed_steps << step.command_short
    end
  end

  if failed_steps.empty?
    email_subject = ''
  else
    email_subject = "#{MacOS.version}: #{failed_steps.join ', '}."
  end

  File.open EMAIL_SUBJECT_FILE, 'w' do |file|
    file.write email_subject
  end
end


safe_system "rm -rf #{HOMEBREW_CACHE}/*" if ARGV.include? "--clean-cache"

exit any_errors ? 0 : 1
