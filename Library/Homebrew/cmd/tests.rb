require "fileutils"

module Homebrew
  def tests
    (HOMEBREW_LIBRARY/"Homebrew/test").cd do
      ENV["TESTOPTS"] = "-v" if ARGV.verbose?
      ENV["HOMEBREW_NO_COMPAT"] = "1" if ARGV.include? "--no-compat"
      if ARGV.include? "--coverage"
        ENV["HOMEBREW_TESTS_COVERAGE"] = "1"
        FileUtils.rm_f "coverage/.resultset.json"
      end

      # Override author/committer as global settings might be invalid and thus
      # will cause silent failure during the setup of dummy Git repositories.
      %w[AUTHOR COMMITTER].each do |role|
        ENV["GIT_#{role}_NAME"] = "brew tests"
        ENV["GIT_#{role}_EMAIL"] = "brew-tests@localhost"
      end

      Homebrew.install_gem_setup_path! "bundler"
      unless quiet_system("bundle", "check")
        system "bundle", "install", "--path", "vendor/bundle"
      end

      # Make it easier to reproduce test runs.
      ENV["SEED"] = ARGV.next if ARGV.include? "--seed"

      args = []
      args << "--trace" if ARGV.include? "--trace"
      if ARGV.value("only")
        test_name, test_method = ARGV.value("only").split("/", 2)
        args << "TEST=test_#{test_name}.rb"
        args << "TESTOPTS=--name=test_#{test_method}" if test_method
      end
      args += ARGV.named.select { |v| v[/^TEST(OPTS)?=/] }
      system "bundle", "exec", "rake", "test", *args

      Homebrew.failed = !$?.success?

      if (fs_leak_log = HOMEBREW_LIBRARY/"Homebrew/test/fs_leak_log").file?
        fs_leak_log_content = fs_leak_log.read
        unless fs_leak_log_content.empty?
          opoo "File leak is detected"
          puts fs_leak_log_content
          Homebrew.failed = true
        end
      end
    end
  end
end
