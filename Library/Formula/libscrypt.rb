require "formula"

class Libscrypt < Formula
  homepage "https://lolware.net/libscrypt.html"
  url "https://github.com/technion/libscrypt/archive/v1.17.tar.gz"
  sha1 "27a36e4f7ae35f44a4bb8e8f922883a9323d9b9c"

  def install
    system "make", "install", "PREFIX=#{prefix}", "LDFLAGS=", "CFLAGS_EXTRA="
    system "make", "check", "LDFLAGS=", "CFLAGS_EXTRA="
    # libscrypt builds a shared object in the non-OS X style (.so.0), so we
    # rename it to the OS X convention of using .dylib. See
    # https://github.com/technion/libscrypt/issues/12
    system "mv", "#{lib}/libscrypt.so.0", "#{lib}/libscrypt.dylib"
  end
end
