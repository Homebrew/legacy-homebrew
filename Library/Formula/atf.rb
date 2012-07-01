require 'formula'

class Atf < Formula
  homepage 'http://code.google.com/p/kyua/wiki/ATF'
  url 'http://kyua.googlecode.com/files/atf-0.15.tar.gz'
  sha256 '0c7242a107c7e308feed8fac45a194a6f6c8d90283add576cfc3dab0fcd61b2b'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system 'make'
    ENV.j1  # Fixes an llvm race condition error where a file exists.
    system 'make install'
  end
end
