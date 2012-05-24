require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class GitPublish < Formula
  homepage 'http://code.google.com/p/git-publish/'
  url 'http://git-publish.googlecode.com/files/git-publish-1.0.tar.bz2'
  md5 '3a58db94f5f13eaa2cb5f9969376e073'

  def install
    bin.install 'git-publish'
  end

  def test
    system "git-publish", "-h"
  end
end
