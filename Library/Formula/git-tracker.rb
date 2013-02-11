require 'formula'

class GitTracker < Formula
  homepage 'https://github.com/stevenharman/git_tracker'
  url 'https://github.com/stevenharman/git_tracker/tarball/v1.5.1'
  sha1 'f4f3491889a034834efe322ce1f545ed29387567'

  head 'https://github.com/stevenharman/git_tracker.git'

  def install
    rake 'standalone:install', "prefix=#{prefix}"
  end

  def test
    `#{bin}/git-tracker test-command`.chomp == 'git-tracker is here. How are you?'
  end
end
