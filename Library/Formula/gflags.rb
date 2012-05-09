require 'formula'

class Gflags < Formula
  url 'http://gflags.googlecode.com/files/gflags-2.0.tar.gz'

  homepage 'http://code.google.com/p/google-gflags/'
  sha1 'dfb0add1b59433308749875ac42796c41e824908'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
