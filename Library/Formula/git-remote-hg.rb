require "formula"

class GitRemoteHg < Formula
  homepage "http://felipec.wordpress.com/2012/11/13/git-remote-hg-bzr-2/"
  url "https://raw.githubusercontent.com/felipec/git-remote-hg/master/git-remote-hg"
  version "2012.11.13"
  sha1 "096f517bd78982d82e333e0779dfc6fd0b2e0929"

  def install
    # This is a script download and install brew
    bin.install "git-remote-hg"
  end

  test do
  end
end
