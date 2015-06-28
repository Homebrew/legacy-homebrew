class Bgpdump < Formula
  homepage "https://bitbucket.org/ripencc/bgpdump/wiki/Home"
  url "http://www.ris.ripe.net/source/bgpdump/libbgpdump-1.4.99.14.tgz"
  sha256 "cfa3d4c0df85acaf90612ae9374fb88e01968ba49d3f8d57a080b39085009b08"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/bgpdump -T"
  end
end
