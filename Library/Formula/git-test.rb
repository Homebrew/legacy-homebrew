class GitTest < Formula
  desc "Run tests on each distinct tree in a revision list"
  homepage "https://github.com/spotify/git-test"
  url "https://github.com/spotify/git-test/archive/v1.0.1.tar.gz"
  sha256 "1273d97644edf3690cc0310a1f6f33856f83bf736599c54150db7a7ad9e43983"

  bottle :unneeded

  def install
    share.install "test.sh"
    bin.install "git-test"
    man1.install "git-test.1"
  end

  test do
    system "git", "init"
    ln_s "#{bin}/git-test", testpath
    cp "#{share}/test.sh", testpath
    chmod 0755, "test.sh"
    system "git", "add", "test.sh"
    system "git", "commit", "-m", "initial commit"
    ENV["TERM"] = "xterm"
    system "#{bin}/git-test", "-v", "HEAD", "--verify='./test.sh'"
  end
end
