# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Sshconfig < Formula
  desc "Minimal command to Add/Remove/list ssh aliases in $HOME/.ssh/config"
  homepage "https://github.com/Ara4Sh/sshconfig"
  url "https://github.com/Ara4Sh/sshconfig/archive/v1.2.tar.gz"
  version "1.2"
  sha256 "0cad9e7a447cf1490f10b9d5ec5637797cd719c412e917dfee4f9799569826b0"

  # depends_on "cmake" => :build
  # depends_on :x11 # if your formula requires any X11/XQuartz components

  def install
	bin.install "sshconfig"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test sshconfig`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "#{bin}/sshconfig"
  end
end
