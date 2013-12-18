require 'formula'

class Fribidi < Formula
  homepage 'http://fribidi.org/'
  url 'http://fribidi.org/download/fribidi-0.19.5.tar.bz2'
  sha1 '58445266df185f7e5109f356c0261d41db39182a'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
