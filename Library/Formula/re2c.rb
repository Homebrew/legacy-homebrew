require 'formula'

class Re2c < Formula
  homepage 'http://re2c.org'
  url 'https://downloads.sourceforge.net/project/re2c/re2c/0.13.6/re2c-0.13.6.tar.gz'
  sha1 'b272048550db56aea2ec1a0a1bce759b90b778fa'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
