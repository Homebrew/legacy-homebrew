require 'formula'

class Shtool < Formula
  homepage 'https://www.gnu.org/software/shtool/'
  url 'http://ftpmirror.gnu.org/shtool/shtool-2.0.8.tar.gz'
  mirror 'https://ftp.gnu.org/gnu/shtool/shtool-2.0.8.tar.gz'
  sha1 '4b974f92d3932ea121e311e3b22c328d3b3572d4'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
