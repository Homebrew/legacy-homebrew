require 'formula'

class GitSvnAbandon < Formula
  homepage 'https://github.com/nothingmuch/git-svn-abandon'
  head 'https://github.com/nothingmuch/git-svn-abandon.git'

  # Pending request for stable tab:
  # https://github.com/nothingmuch/git-svn-abandon/issues/2

  def install
    bin.install Dir['git-svn-abandon-*']
  end
end
