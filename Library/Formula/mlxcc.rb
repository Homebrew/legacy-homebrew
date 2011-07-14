require 'formula'

class Mlxcc < Formula
  url 'http://developer.marklogic.com/download/code/libmlxcc/releases/src/mlxcc-0.5.3.tar.gz'
  homepage 'http://developer.marklogic.com'
  md5 '2dae6b8cc21e71ecdc65b514aa382d11'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
