require "formula"

class Libscrypt < Formula
  homepage "https://lolware.net/libscrypt.html"
  url "https://github.com/technion/libscrypt/archive/v1.19.tar.gz"
  sha1 "fb457aab4561a929dda2872da52b02710c07b7a5"

  def install
    system "make", "install-osx", "PREFIX=#{prefix}", "LDFLAGS=", "CFLAGS_EXTRA="
    system "make", "check", "LDFLAGS=", "CFLAGS_EXTRA="
  end
end
