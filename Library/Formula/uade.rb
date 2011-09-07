require 'formula'

class Uade < Formula
  url 'http://zakalwe.fi/uade/uade2/uade-2.13.tar.bz2'
  homepage 'http://zakalwe.fi/uade/'
  md5 '29bb1018b7fa58f93b246264c160bdc6'

  depends_on 'pkg-config' => :build
  depends_on 'libao'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
