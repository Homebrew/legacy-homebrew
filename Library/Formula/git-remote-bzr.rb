require "formula"

class GitRemoteBzr < Formula
  homepage "http://felipec.wordpress.com/2012/11/13/git-remote-hg-bzr-2/"
  url "https://raw.githubusercontent.com/felipec/git-remote-bzr/master/git-remote-bzr"
  version "2012.11.13"
  sha1 "b7b27ba85b3e1a588eaef50bbdb41127cbb8c6e9"

  def install
    # This is a script download and install brew
    bin.install "git-remote-bzr"
  end

  test do
  end
end
