class Rush < Formula
  homepage "https://www.gnu.org/software/rush/"
  url "http://ftpmirror.gnu.org/rush/rush-1.7.tar.gz"
  mirror "https://ftp.gnu.org/gnu/rush/rush-1.7.tar.gz"
  sha256 "35077fa36902fd451db52b49bf059992a20cc8ea031437171f384670d77a003a"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/rush", "-h"
  end
end
