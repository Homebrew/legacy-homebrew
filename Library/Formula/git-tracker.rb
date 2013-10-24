require 'formula'

class GitTracker < Formula
  homepage 'https://github.com/stevenharman/git_tracker'
  url 'https://github.com/stevenharman/git_tracker/archive/v1.5.1.tar.gz'
  sha1 '2b492583b51fc84186ddb3f72ad363f84d7baf53'

  head 'https://github.com/stevenharman/git_tracker.git'

  def install
    rake 'standalone:install', "prefix=#{prefix}"
  end

  test do
    require 'open3'
    Open3.popen3("#{bin}/git-tracker", "test-command") do |_, stdout, _|
      assert_equal "git-tracker is here. How are you?", stdout.read.strip
    end
  end
end
