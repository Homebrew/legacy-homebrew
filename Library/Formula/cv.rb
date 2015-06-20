class Cv < Formula
  desc "Coreutils Viewer: Show progress for coreutils"
  homepage "https://github.com/Xfennec/cv"
  url "https://github.com/Xfennec/cv/archive/v0.7.1.tar.gz"
  sha256 "c8ab81b09f6026cbfdc94c9453d4a0fad7ea5e1e34efd1c1559f88f7398cf4ee"
  head "https://github.com/Xfennec/cv.git"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "cv", "--help"
    pid = fork do
      system "/bin/dd", "if=/dev/zero", "of=/dev/null", "bs=100000", "count=1000000"
    end
    sleep 1
    begin
      assert_match /dd/, shell_output("cv")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
