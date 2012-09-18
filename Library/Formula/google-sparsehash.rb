require 'formula'

class GoogleSparsehash < Formula
  homepage 'http://code.google.com/p/google-sparsehash/'
  url 'http://google-sparsehash.googlecode.com/files/sparsehash-1.12.tar.gz'
  sha1 '6c6da5d03b6b71ba69cf056087a94b5f01048782'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make check"
    system "make install"
  end
end
