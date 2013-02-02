require 'formula'

class GitTracker < Formula
  homepage 'https://github.com/stevenharman/git_tracker'
  url 'https://github.com/stevenharman/git_tracker/tarball/v1.5.0'
  sha1 '55c751b04ce6b7bb30232fbc367924af2f352017'

  head 'https://github.com/stevenharman/git_tracker.git'

  def install
    rake 'standalone:install', "prefix=#{prefix}"
  end

  def test
    `#{bin}/git-tracker test-command`.chomp == 'git-tracker is here. How are you?'
  end
end
