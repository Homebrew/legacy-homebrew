module Homebrew
  def tests
    (HOMEBREW_LIBRARY/'Homebrew/test').cd do
      ENV['TESTOPTS'] = '-v' if ARGV.verbose?
      quiet_system("bundle", "check") || system("bundle", "install")
      system "bundle", "exec", "rake", "test"
      exit $?.exitstatus
    end
  end
end
