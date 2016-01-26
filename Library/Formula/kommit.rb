class Kommit < Formula
  desc "More detailed commit messages without committing!"
  homepage "https://github.com/bilgi-webteam/kommit"
  url "https://github.com/bilgi-webteam/kommit/archive/v0.1.4.tar.gz"
  sha256 "ffc017790b24c238848f83e483e22874ece73af22d3261a59e465d667e9f3c13"

  def install
    bin.install "bin/kommit"
  end
  def caveats; <<-EOS.undent
    If you like to combine with git, create a symlink;
      ln -s #{bin}/kommit #{bin}/git-kommit
    EOS
  test do
    system "git", "init"
    system "#{bin}/kommit", "-m", "Hello"
    assert_match /Hello/, shell_output("#{bin}/kommit -s /dev/null 2>&1")
  end
end
