require "extend/ENV"

module Homebrew
  def update_test
    homebrew_repository_git = HOMEBREW_REPOSITORY/".git"

    mktemp do
      curdir = Pathname.new(Dir.pwd)

      # copy Homebrew installation
      cp_r homebrew_repository_git, curdir/".git"
      safe_system "git", "checkout", "--force", "master"
      safe_system "git", "reset", "--hard", "origin/master"

      # Set git origin
      safe_system "git", "config", "remote.origin.url", "file://#{homebrew_repository_git}"

      # update ENV["PATH"]
      ENV.extend(Stdenv)
      ENV.prepend_path "PATH", "#{curdir}/bin"

      # run brew update
      safe_system "brew", "update"
    end
  end
end
