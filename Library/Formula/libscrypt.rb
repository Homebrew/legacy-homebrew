class Libscrypt < Formula
  desc "Library for scrypt"
  homepage "https://lolware.net/libscrypt.html"
  url "https://github.com/technion/libscrypt/archive/v1.20.tar.gz"
  sha256 "6074add2170b7d00e080fe3a58d3dec76850a4f272d488f5e8cc3c4acb6d8e21"

  bottle do
    cellar :any
    sha1 "0e2111337ef3f998663f699dcc860b030c8819d6" => :yosemite
    sha1 "731edb6e1bd1bd2b4b92fc039061d8f13862b381" => :mavericks
    sha1 "426bd83082db11bfa5bc88c20a9c0482bfeab850" => :mountain_lion
  end

  def install
    system "make", "install-osx", "PREFIX=#{prefix}", "LDFLAGS=", "CFLAGS_EXTRA="
    system "make", "check", "LDFLAGS=", "CFLAGS_EXTRA="
  end
end
