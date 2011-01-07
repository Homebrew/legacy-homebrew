require 'formula'

class Xaric <Formula
  url 'http://xaric.org/software/xaric/releases/xaric-0.13.6.tar.gz'
  homepage 'http://xaric.org/'
  md5 '3523edcd8c8d5234b87c56c86c2dfdfc'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
