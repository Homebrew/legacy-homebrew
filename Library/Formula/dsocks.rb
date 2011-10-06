require 'formula'

class Dsocks < Formula
  url 'http://monkey.org/~dugsong/dsocks/dsocks-1.7.tar.gz'
  homepage 'http://monkey.org/~dugsong/dsocks/'
  md5 'b2c87206e3f526bdab8e990a0168ab6c'

  def install
    system "llvm-gcc", "-O3", "-shared", "-o", "libdsocks.dylib", "dsocks.c", "atomicio.c", "-lresolv"
    inreplace "dsocks.sh", "/usr/local", HOMEBREW_PREFIX

    lib.install "libdsocks.dylib"
    bin.install "dsocks.sh"
  end
end
