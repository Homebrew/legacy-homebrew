require 'formula'

class GoogleSparsehash < Formula
  url 'http://google-sparsehash.googlecode.com/files/sparsehash-1.7.tar.gz'
  homepage 'http://code.google.com/p/google-sparsehash/'
  sha1 'b9355e6aa2564b6a2d9fc2e1ac3f9773dbca8f59'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make check"
    system "make install"
  end
end
