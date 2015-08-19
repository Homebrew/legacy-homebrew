class GitTracker < Formula
  desc "Integrate Pivotal Tracker into git use"
  homepage "https://github.com/stevenharman/git_tracker"
  url "https://github.com/stevenharman/git_tracker/archive/v1.6.3.tar.gz"
  sha256 "8864f4a3699c32ff56b3131bfe809a81b7446b2610cf0896015ac49a39b039c9"

  head "https://github.com/stevenharman/git_tracker.git"

  def install
    rake "standalone:install", "prefix=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/git-tracker help")
    assert_match /git-tracker \d+(\.\d+)* is installed\./, output
  end
end
