require 'formula'

class Atf < Formula
  homepage 'http://code.google.com/p/kyua/wiki/ATF'
  url 'http://kyua.googlecode.com/files/atf-0.16.tar.gz'
  sha256 'f33a85f4a0677f40be406baaf6a5a749ca02870af9707f7606a0f3fa613c8339'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system 'make'
    ENV.j1  # Fixes an llvm race condition error where a file exists.
    system 'make install'
  end
end
