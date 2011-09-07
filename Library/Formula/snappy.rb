require 'formula'

class Snappy < Formula
  url 'http://snappy.googlecode.com/files/snappy-1.0.3.tar.gz'
  homepage 'http://snappy.googlecode.com'
  md5 '9d328e39edbf01c0906c6293234a7637'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
