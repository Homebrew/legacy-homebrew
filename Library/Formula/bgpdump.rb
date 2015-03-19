class Bgpdump < Formula
  homepage "https://bitbucket.org/ripencc/bgpdump/wiki/Home"
  url "http://www.ris.ripe.net/source/bgpdump/libbgpdump-1.4.99.13.tgz"
  sha256 "7551a285fa5c0885aec7290e1f316e58968baab70a4f3467f8f70868d338311e"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "example" # Workaround for broken Makefile
    system "make", "install"
  end

  test do
    system "#{bin}/bgpdump"
  end
end
