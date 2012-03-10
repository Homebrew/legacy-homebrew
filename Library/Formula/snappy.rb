require 'formula'

class Snappy < Formula
  url 'http://snappy.googlecode.com/files/snappy-1.0.4.tar.gz'
  homepage 'http://snappy.googlecode.com'
  md5 'b69151652e82168bc5c643bcd6f07162'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
