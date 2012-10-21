module Homebrew extend self
  def tests
    (HOMEBREW_LIBRARY/'Homebrew/test').cd do
      ENV['TESTOPTS'] = '-v' if ARGV.verbose?
      system "rake", "test"
      exit $?.exitstatus
    end
  end
end

Homebrew.tests
