module Homebrew
  def tests
    (HOMEBREW_LIBRARY/"Homebrew/test").cd do
      ENV["TESTOPTS"] = "-v" if ARGV.verbose?
      Homebrew.install_gem_setup_path! "bundler"
      quiet_system("bundle", "check") || \
        system("bundle", "install", "--path", "vendor/bundle")
      system "bundle", "exec", "rake", "test"
      exit $?.exitstatus
    end
  end
end
