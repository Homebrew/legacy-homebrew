require 'formula'

class Gflags < Formula
  url 'http://google-gflags.googlecode.com/files/gflags-1.6.tar.gz'
  homepage 'http://code.google.com/p/google-gflags/'
  sha1 '3901cbc03fdfec0ae661502e0314ac88f339d95e'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
