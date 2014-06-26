require 'formula'

class Fribidi < Formula
  homepage 'http://fribidi.org/'
  url 'http://fribidi.org/download/fribidi-0.19.6.tar.bz2'
  sha1 '5a6ff82fdee31d27053c39e03223666ac1cb7a6a'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
