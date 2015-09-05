class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.9.2.tar.gz"
  sha256 "146fc72ad2e31f6c6b6badbf1a412e6b88cb7ef5a0850475efae32e0c561c091"
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 "908fdba172e7d559382baeab3d36a5a9792042a3051dc539489f7c922a82fc1a" => :yosemite
    sha256 "3e48aaf8bc11985c72030cd1868daf82b7de9227f129f15c98d54242827f2397" => :mavericks
    sha256 "43310698b968c5d252498889d0489d3d8449d3a5f6d3f431fb004fa69f4df6e7" => :mountain_lion
  end

  depends_on "concurrencykit"
  depends_on "jlog"
  depends_on "openssl"

  def install
    inreplace "Makefile", "/usr/lib/dtrace", "#{lib}/dtrace"
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
    bin.install "fqc", "fq_sndr", "fq_rcvr"
  end

  test do
    pid = fork { exec sbin/"fqd", "-D", "-c", testpath/"test.sqlite" }
    sleep 1
    begin
      assert_match /Circonus Fq Operational Dashboard/, shell_output("curl 127.0.0.1:8765")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
