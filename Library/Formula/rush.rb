require 'formula'

class Rush < Formula
  url 'http://ftp.gnu.org/gnu/rush/rush-1.6.tar.gz'
  homepage 'http://www.gnu.org/software/rush/'
  md5 '32087472928220d0009fd65670d42741'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
