require 'formula'

class GoogleSparsehash < Formula
  url 'http://google-sparsehash.googlecode.com/files/sparsehash-1.11.tar.gz'
  homepage 'http://code.google.com/p/google-sparsehash/'
  sha1 '9bd33e0336420058ff96873f7651e8e18aaea056'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make check"
    system "make install"
  end
end
