class Stress < Formula
  homepage "http://people.seas.harvard.edu/~apw/stress/"
  url "http://people.seas.harvard.edu/~apw/stress/stress-1.0.4.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/stress/stress_1.0.4.orig.tar.gz"
  sha256 "057e4fc2a7706411e1014bf172e4f94b63a12f18412378fca8684ca92408825b"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"stress", "--cpu", "2", "--io", "1", "--vm", "1", "--vm-bytes", "128M", "--timeout", "1s", "--verbose"
  end
end
