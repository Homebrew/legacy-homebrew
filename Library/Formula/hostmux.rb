# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Hostmux < Formula
  desc "hostmux is a small wrapper script for tmux to easily connect to a series of hosts via ssh and open a split pane for each of the hosts. Using the synchronize-pane feature of tmux, commands can be easily broadcasted/multiplexed. This is a light weight replacement for tools like csshX on OS X."
  homepage "https://github.com/hukl/hostmux/"
  url "https://github.com/hukl/hostmux/archive/1.0.0.tar.gz"
  version "1.0.0"
  sha256 "83b0e55f728d7ac1f1a6929477648a9319e6bacfce3502ae4abf0727ac57ca67"

  # depends_on "cmake" => :build
  depends_on "tmux"

  def install
    bin.install "hostmux"
    man1.install "man/hostmux.1"
    zsh_completion.install "zsh-completion/_hostmux"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test hostmux`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "hostmux"
  end
end
