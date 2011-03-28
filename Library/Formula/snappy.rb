require 'formula'

class Snappy < Formula
  url 'http://snappy.googlecode.com/files/snappy-1.0.1.tar.gz'
  homepage 'http://snappy.googlecode.com'
  md5 'b3af7263f0481f0c03267bb4117fce3a'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
