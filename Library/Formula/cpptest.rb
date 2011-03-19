require 'formula'

class Cpptest < Formula
  url 'http://downloads.sourceforge.net/project/cpptest/cpptest/cpptest-1.1.1/cpptest-1.1.1.tar.gz'
  homepage 'http://cpptest.sourceforge.net/'
  md5 'b50379402d69d40417add19ef88f9938'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
