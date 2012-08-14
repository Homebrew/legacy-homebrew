require 'formula'

class Libao < Formula
  url 'http://downloads.xiph.org/releases/ao/libao-1.1.0.tar.gz'
  md5 '2b2508c29bc97e4dc218fa162cf883c8'
  homepage 'http://www.xiph.org/ao/'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make install"
  end
end
