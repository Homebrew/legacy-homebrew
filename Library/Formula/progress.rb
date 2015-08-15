class Progress < Formula
  desc "Coreutils Viewer: Show progress for coreutils"
  homepage "https://github.com/Xfennec/progress"
  url "https://github.com/Xfennec/progress/archive/v0.8.tar.gz"
  sha256 "52ad6d805eb9826de297ba495cfde3df1deb6288f97ff67e7f93431efa006d34"
  head "https://github.com/Xfennec/progress.git"

  bottle do
    cellar :any
    sha256 "ca3b822899bd8c370fb4049f9b68574ad3bc897495bd6bb985279b29c70c554c" => :yosemite
    sha256 "0ade55ecc626b9559aa842b190cebcef0791287b019502eff106abe53960a4c7" => :mavericks
    sha256 "849b187b69a23fbfad43121337a89c618426080571bc6d87e99b067a3dcfe4c7" => :mountain_lion
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
