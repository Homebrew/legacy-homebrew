require 'formula'

class Jed < Formula
  url 'ftp://space.mit.edu/pub/davis/jed/v0.99/jed-0.99-19.tar.bz2'
  homepage 'http://www.jedsoft.org/jed/'
  md5 'c9b2f58a3defc6f61faa1ce7d6d629ea'

  depends_on 's-lang'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"

    ENV.deparallelize
    system "make install"
  end
end
