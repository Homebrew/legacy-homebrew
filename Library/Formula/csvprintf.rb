require 'formula'

class Csvprintf < Formula
  homepage 'http://code.google.com/p/csvprintf/'
  url 'http://csvprintf.googlecode.com/files/csvprintf-1.0.3.tar.gz'
  sha1 'ee5ee6728a44cc7d0961b0960c7a444372752931'

  def install
    ENV.append 'LDFLAGS', '-liconv'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
