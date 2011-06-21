require 'formula'

class GitPullRequest < Formula
  head 'https://github.com/splitbrain/git-pull-request.git'
  homepage 'http://www.splitbrain.org/blog/2011-06/19-automate_github_pull_requests'

  def install
    bin.install Dir['git-*']
  end

  def patches
    ["https://raw.github.com/gist/1038403/git-pull-request-osx.diff"]
  end
end
