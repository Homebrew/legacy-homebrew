module Homebrew
  def tests
    (HOMEBREW_LIBRARY/'Homebrew/test').cd do
      ENV['TESTOPTS'] = '-v' if ARGV.verbose?
      quiet_system("gem", "list", "--installed", "bundler") || \
        system("gem", "install", "--no-ri", "--no-rdoc",
               "--user-install", "bundler")
      require 'rubygems'
      ENV["PATH"] = "#{Gem.user_dir}/bin:#{ENV["PATH"]}"
      quiet_system("bundle", "check") || \
        system("bundle", "install", "--path", "vendor/bundle")
      system "bundle", "exec", "rake", "test"
      exit $?.exitstatus
    end
  end
end
