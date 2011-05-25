require 'formula'

class LcdfTypetools < Formula
  url 'http://www.lcdf.org/type/lcdf-typetools-2.88.tar.gz'
  homepage 'http://www.lcdf.org/type/'
  md5 '526c6877e0c6145c1c821e89276b2a32'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-kpathsea"
    system "make install"
  end
end
