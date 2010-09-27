require 'formula'

class GitHg < Formula
  head 'git://github.com/offbytwo/git-hg.git'
  homepage 'http://offbytwo.com/git-hg/'

  def install
    # Install all
    prefix.install Dir['*']
  end
end

