require 'formula'

class Snobol4 < Formula
  url 'ftp://ftp.ultimate.com/snobol/snobol4-1.2.tar.gz'
  homepage 'http://www.snobol4.org/'
  md5 '5265d1e21b8d1963e0c7fe830c3d5172'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
