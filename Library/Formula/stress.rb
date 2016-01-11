class Stress < Formula
  desc "Tool to impose load on and stress test a computer system"
  homepage "http://people.seas.harvard.edu/~apw/stress/"
  url "http://people.seas.harvard.edu/~apw/stress/stress-1.0.4.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/stress/stress_1.0.4.orig.tar.gz"
  sha256 "057e4fc2a7706411e1014bf172e4f94b63a12f18412378fca8684ca92408825b"

  bottle do
    cellar :any
    sha256 "845f44585d0a3749c163300029f832125950d37af4a5b53c0b20fb143e6db014" => :yosemite
    sha256 "6741dc72df4a43cfe2c947d9e50d08df1e35029025ff2436d5a20a01117f4fb6" => :mavericks
    sha256 "28ac09ff04e83b174f915a6306de69f70d8b81f6316b0f1884bf2ac8061134ee" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"stress", "--cpu", "2", "--io", "1", "--vm", "1", "--vm-bytes", "128M", "--timeout", "1s", "--verbose"
  end
end
