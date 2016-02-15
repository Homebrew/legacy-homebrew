class SafeRm < Formula
  desc "Wraps rm to prevent dangerous deletion of files"
  homepage "https://launchpad.net/safe-rm"
  url "https://launchpad.net/safe-rm/trunk/0.12/+download/safe-rm-0.12.tar.gz"
  sha256 "1c9d3113591e249301fd00fff51152069ab71cd518b32bfcf6848a8d6c3054e2"
  head "http://repo.or.cz/safe-rm.git"

  bottle :unneeded

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
