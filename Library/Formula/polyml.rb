require 'formula'

class Polyml < Formula
  homepage 'http://www.polyml.org'
  url 'http://downloads.sourceforge.net/project/polyml/polyml/5.5.1/polyml.5.5.1.tar.gz'
  sha1 'f5a0d289eb0a891af5ac6e897ccc7718ccf32d89'

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
