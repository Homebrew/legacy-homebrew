require 'formula'

class Re2c < Formula
  homepage 'http://re2c.org'
  url 'http://downloads.sourceforge.net/project/re2c/re2c/0.13.5/re2c-0.13.5.tar.gz'
  sha1 '3d334efab53a4a051a2b189b49a849e13523b6c0'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
