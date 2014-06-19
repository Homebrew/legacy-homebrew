module Homebrew
  def tests
    (HOMEBREW_LIBRARY/'Homebrew/test').cd do
      ENV['TESTOPTS'] = '-v' if ARGV.verbose?
      system "rake", "deps", "test"
      exit $?.exitstatus
    end
  end
end
