require 'formula'

class Dxflib < Formula
  homepage 'http://www.ribbonsoft.com/dxflib.html'
  url 'ftp://anonymous:anonymous@ribbonsoft.com/archives/dxflib/dxflib-2.2.0.0-1.src.tar.gz'
  version '2.2.0.0-1'
  md5 '0eb6bef3b3a702012eeb4e99ef1aa3f1'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
