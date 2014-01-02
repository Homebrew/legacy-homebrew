require 'formula'

class Blitzwave < Formula
  homepage 'http://oschulz.github.io/blitzwave'
  url 'https://github.com/downloads/oschulz/blitzwave/blitzwave-0.7.1.tar.gz'
  sha1 '2a53f1a9b7967897415afce256f02693a35f380e'

  depends_on 'blitz'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
