class Progress < Formula
  desc "Coreutils Viewer: Show progress for coreutils"
  homepage "https://github.com/Xfennec/progress"
  url "https://github.com/Xfennec/progress/archive/v0.8.tar.gz"
  sha256 "52ad6d805eb9826de297ba495cfde3df1deb6288f97ff67e7f93431efa006d34"
  head "https://github.com/Xfennec/progress.git"

  bottle do
    cellar :any
    sha256 "6efdb41f6ff0b3e50ba4804ffd1fdb686bdbda67eea25bec556c78f7fb3c1641" => :yosemite
    sha256 "b1075fc37c520c1167582ab54d8f7d3a688b19ca34695d07caff731dd9129884" => :mavericks
    sha256 "f26dc6c88b6417492e8d4dfeccf4559452cd409f7a25d047084a61e888c07e59" => :mountain_lion
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    pid = fork do
      system "/bin/dd", "if=/dev/zero", "of=/dev/null", "bs=100000", "count=1000000"
    end
    sleep 1
    begin
      assert_match(/dd/, shell_output("#{bin}/progress"))
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
