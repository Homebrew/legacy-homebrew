class Dsocks < Formula
  desc "SOCKS client wrapper for *BSD/OS X"
  homepage "http://monkey.org/~dugsong/dsocks/"
  url "https://dsocks.googlecode.com/files/dsocks-1.8.tar.gz"
  sha256 "2b57fb487633f6d8b002f7fe1755480ae864c5e854e88b619329d9f51c980f1d"

  def install
    system "#{ENV.cc} #{ENV.cflags} -shared -o libdsocks.dylib dsocks.c atomicio.c -lresolv"
    inreplace "dsocks.sh", "/usr/local", HOMEBREW_PREFIX

    lib.install "libdsocks.dylib"
    bin.install "dsocks.sh"
  end
end
