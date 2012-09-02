require 'formula'

class Dsocks < Formula
  url 'http://dsocks.googlecode.com/files/dsocks-1.7.tar.gz'
  homepage 'http://monkey.org/~dugsong/dsocks/'
  sha1 '7be86578e525312008e36c0c5800fefee0ea481a'

  def install
    system "#{ENV.cc} #{ENV.cflags} -shared -o libdsocks.dylib dsocks.c atomicio.c -lresolv"
    inreplace "dsocks.sh", "/usr/local", HOMEBREW_PREFIX

    lib.install "libdsocks.dylib"
    bin.install "dsocks.sh"
  end
end
