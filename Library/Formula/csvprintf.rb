require 'formula'

class Csvprintf < Formula
  homepage 'http://code.google.com/p/csvprintf/'
  url 'http://csvprintf.googlecode.com/files/csvprintf-1.0.1.tar.gz'
  sha1 '715c0206ef1dde790af26ca35c1bbb68cd727444'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
