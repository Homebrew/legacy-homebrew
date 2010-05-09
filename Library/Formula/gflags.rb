require 'formula'

class Gflags <Formula
  url 'http://google-gflags.googlecode.com/files/gflags-1.3.tar.gz'
  homepage 'http://code.google.com/p/google-gflags/'
  md5 '6da3d3b9cd82c222b521ae686b6cfa8b'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
