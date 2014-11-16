require 'formula'

class GitTracker < Formula
  homepage 'https://github.com/stevenharman/git_tracker'
  url 'https://github.com/stevenharman/git_tracker/archive/v1.6.3.tar.gz'
  sha1 'c748e564f176165dba2498637e0b99f27647b88a'

  head 'https://github.com/stevenharman/git_tracker.git'

  def install
    rake 'standalone:install', "prefix=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/git-tracker help")
    assert_match /git-tracker \d+(\.\d+)* is installed\./, output
  end
end
