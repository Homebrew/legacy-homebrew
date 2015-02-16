class SafeRm < Formula
  homepage "https://launchpad.net/safe-rm"
  url "https://launchpad.net/safe-rm/trunk/0.12/+download/safe-rm-0.12.tar.gz"
  sha1 "f0abd96a6898ad64389bf4be8773c899986b4618"

  head "https://gitorious.org/safe-rm/mainline.git"

  def install
    bin.install "safe-rm"
  end

  test do
    foo = testpath/"foo"
    bar = testpath/"bar"
    (testpath/".config").mkdir
    (testpath/".config/safe-rm").write bar
    touch foo
    touch bar
    system "#{bin}/safe-rm", foo
    assert !File.exist?(foo)
    shell_output("#{bin}/safe-rm #{bar} 2>&1", 64)
    assert File.exist?(bar)
  end
end
