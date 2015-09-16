require "extend/ENV"

module Homebrew
  def update_test
    cd HOMEBREW_REPOSITORY
    start_sha1 = Utils.popen_read("git", "rev-parse", "origin/master").chomp
    end_sha1 = Utils.popen_read("git", "rev-parse", "HEAD").chomp

    mktemp do
      curdir = Pathname.new(Dir.pwd)

      oh1 "Setup test environment..."
      # copy Homebrew installation
      safe_system "git", "clone", "--local", "#{HOMEBREW_REPOSITORY}/.git", "."

      # set git origin to another copy
      safe_system "git", "clone", "--local", "--bare", "#{HOMEBREW_REPOSITORY}/.git", "remote.git"
      safe_system "git", "config", "remote.origin.url", "#{curdir}/remote.git"

      # force push origin to end_sha1
      safe_system "git", "checkout", "--force", "master"
      safe_system "git", "reset", "--hard", end_sha1
      safe_system "git", "push", "--force", "origin", "master"

      # set test copy to start_sha1
      safe_system "git", "reset", "--hard", start_sha1

      # update ENV["PATH"]
      ENV.extend(Stdenv)
      ENV.prepend_path "PATH", "#{curdir}/bin"

      # run brew update
      oh1 "Running brew update..."
      safe_system "brew", "update", "--verbose"
    end
  end
end
