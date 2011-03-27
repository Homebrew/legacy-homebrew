require 'formula'

class Snappy < Formula
  url 'http://snappy.googlecode.com/files/snappy-1.0.0.tar.gz'
  homepage 'http://snappy.googlecode.com'
  md5 '9d83bdcf0c79a8de608fa969c2909204'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
