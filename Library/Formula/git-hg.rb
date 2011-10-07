require 'formula'

class GitHg < Formula
  head 'https://github.com/offbytwo/git-hg.git'
  homepage 'http://offbytwo.com/git-hg/'

  def install
    prefix.install Dir['*']
  end
end

