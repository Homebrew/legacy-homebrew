class Fq < Formula
  desc "A brokered message queue written in C"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.9.1.tar.gz"
  sha256 "9fd8d51211a5ebe776c0e4e61a9d4475ba39e4597fe5cd45ea9a1043da3cf4ef"

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
    pid = fork { exec sbin/"fqd", "-D" }
    sleep 1
    begin
      assert_match /Circonus Fq Operational Dashboard/, shell_output("curl 127.0.0.1:8765")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
