require "formula"

class Libscrypt < Formula
  homepage "https://lolware.net/libscrypt.html"
  url "https://github.com/technion/libscrypt/archive/v1.18.tar.gz"
  sha1 "ff6b0cda00afcb582ca57699322b94166e5f3ab6"

  def install
    system "make", "install-osx", "PREFIX=#{prefix}", "LDFLAGS=", "CFLAGS_EXTRA="
    system "make", "check", "LDFLAGS=", "CFLAGS_EXTRA="
  end
end
