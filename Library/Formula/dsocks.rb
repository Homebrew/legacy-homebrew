require 'formula'

class Dsocks < Formula
  homepage 'http://monkey.org/~dugsong/dsocks/'
  url 'https://dsocks.googlecode.com/files/dsocks-1.8.tar.gz'
  sha1 'd9d58e0ed6ca766841c94b5d15dd268a967c60bc'

  def install
    system "#{ENV.cc} #{ENV.cflags} -shared -o libdsocks.dylib dsocks.c atomicio.c -lresolv"
    inreplace "dsocks.sh", "/usr/local", HOMEBREW_PREFIX

    lib.install "libdsocks.dylib"
    bin.install "dsocks.sh"
  end
end
