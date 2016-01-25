class Kommit < Formula
  desc "More detailed commit messages without committing!"
  homepage "https://github.com/bilgi-webteam/kommit"
  url "https://github.com/bilgi-webteam/kommit/archive/v1.0.0.tar.gz"
  sha256 "d079ba1dcfdf31a35e3d42dbd6adf2450d305e998adb679fb9dc8ea68fa23c22"

  def install
    bin.install "bin/git-kommit"
  end

  test do
    system "git", "init"
    system "#{bin}/git-kommit", "-m", "Hello"
    assert_match /Hello/, shell_output("#{bin}/git-kommit -s /dev/null 2>&1")
  end
end
