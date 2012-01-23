require 'formula'

class GitHg < Formula
  head 'https://github.com/offbytwo/git-hg.git'
  homepage 'http://offbytwo.com/git-hg/'
  
  depends_on 'mercurial'
  depends_on 'mercurial' => :python

  def install
    prefix.install Dir['*']
  end
end

