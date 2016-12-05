class GitWhenMerged < Formula
  desc "Find where a commit was merged in git."
  homepage "https://github.com/mhagger/git-when-merged"
  url "https://github.com/mhagger/git-when-merged/archive/v1.0.0.tar.gz"
  sha256 "1be0f2c660e6e0cef66593aac681163b97027a7be028b6d2b3901fee00639ad7"

  bottle :unneeded

  def install
    bin.install "bin/git-when-merged"
  end

  test do
    system "git", "init"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "foo"
    system "git", "checkout", "-b", "bar"
    touch "bar"
    system "git", "add", "bar"
    system "git", "commit", "-m", "bar"
    system "git", "checkout", "master"
    system "git", "merge", "--no-ff", "bar"
    touch "baz"
    system "git", "add", "baz"
    system "git", "commit", "-m", "baz"
    system "#{bin}/git-when-merged", "bar"
  end
end
