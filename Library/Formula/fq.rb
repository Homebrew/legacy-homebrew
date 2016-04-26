class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.9.2.tar.gz"
  sha256 "146fc72ad2e31f6c6b6badbf1a412e6b88cb7ef5a0850475efae32e0c561c091"
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 "4cf2f275af16dd9c57c5ce2f3aa24dd11be8d74dc73f769e1c4ab7a9404a54fc" => :el_capitan
    sha256 "c5b9b747803913c8fe6876cfe3cb59f85d239047fb373894192f8e58a6e46f0f" => :yosemite
    sha256 "5cf8134810d15d74176c8249bce2816e62dc6ad17747cbc643accb3be190d366" => :mavericks
    sha256 "d88823472545e48204c8c2d9c56cb4f88fc77be081d85ab27c0595f9e0abe490" => :mountain_lion
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
