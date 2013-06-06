require 'formula'

class GoogleSparsehash < Formula
  homepage 'http://code.google.com/p/google-sparsehash/'
  url 'http://sparsehash.googlecode.com/files/sparsehash-2.0.2.tar.gz'
  sha1 '12c7552400b3e20464b3362286653fc17366643e'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make check"
    system "make install"
  end
end
