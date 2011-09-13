require 'formula'

class Gflags < Formula
  url 'http://google-gflags.googlecode.com/files/gflags-1.5.tar.gz'
  homepage 'http://code.google.com/p/google-gflags/'
  sha1 'afefecb4230c0adb7e59e1fdd890a6c14c571f5b'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
