class Cv < Formula
  desc "Coreutils Viewer: Show progress for coreutils"
  homepage "https://github.com/Xfennec/cv"
  url "https://github.com/Xfennec/cv/archive/v0.7.1.tar.gz"
  sha256 "c8ab81b09f6026cbfdc94c9453d4a0fad7ea5e1e34efd1c1559f88f7398cf4ee"
  head "https://github.com/Xfennec/cv.git"

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
