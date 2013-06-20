require 'formula'

class LcdfTypetools < Formula
  homepage 'http://www.lcdf.org/type/'
  url 'http://www.lcdf.org/type/lcdf-typetools-2.98.tar.gz'
  sha256 '26b9be336b3d575555436d139e5a9c40fea58f5b9468516f974ca7bd1eeae17f'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-kpathsea"
    system "make install"
  end
end
