class Wandio < Formula
  desc "LibWandio I/O performance will be improved by doing any compression"
  homepage "http://research.wand.net.nz/software/libwandio.php"
  url "http://research.wand.net.nz/software/wandio/wandio-1.0.3.tar.gz"
  sha256 "31dcc1402ace3023020446d6c7284fd84447f9b36e570206a179895e1eaa705b"

  def install
    system "./configure", "--disable-debug",
                          "--with-http",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wandiocat", "-h"
  end
end
