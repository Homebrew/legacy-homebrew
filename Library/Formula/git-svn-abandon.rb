require 'formula'

class GitSvnAbandon < Formula
  head 'https://github.com/nothingmuch/git-svn-abandon.git'
  homepage 'https://github.com/nothingmuch/git-svn-abandon'

  def install
    bin.install 'git-svn-abandon-cleanup'
    bin.install 'git-svn-abandon-fix-refs'
    bin.install 'git-svn-abandon-msg-filter'
  end
end
