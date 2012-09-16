require 'formula'

class Genders < Formula
  homepage ''
  url 'http://downloads.sourceforge.net/project/genders/genders/1.20-1/genders-1.20.tar.gz'
  sha1 '3a1f3f7897c5443edb4d06bd8093b505078454e8'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
