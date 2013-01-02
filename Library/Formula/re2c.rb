require 'formula'

class Re2c < Formula
  url 'http://downloads.sourceforge.net/project/re2c/re2c/0.13.5/re2c-0.13.5.tar.gz'
  homepage 'http://re2c.org'
  sha1 '3d334efab53a4a051a2b189b49a849e13523b6c0'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
