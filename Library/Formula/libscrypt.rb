class Libscrypt < Formula
  desc "Library for scrypt"
  homepage "https://lolware.net/libscrypt.html"
  url "https://github.com/technion/libscrypt/archive/v1.20.tar.gz"
  sha256 "6074add2170b7d00e080fe3a58d3dec76850a4f272d488f5e8cc3c4acb6d8e21"

  bottle do
    cellar :any
    sha256 "d542be37b69da1feaa86854767c9854703f6a084d18d0f8305098e46bd41e000" => :yosemite
    sha256 "d3efcf02f126ad4dc94c85dd2349470a27596cbce0c0271cc421917a2005b7d1" => :mavericks
    sha256 "7bc3e3d4170a58a0e378e7ca2ac14d448984d68e049244ab7aee5bf09b91f4f6" => :mountain_lion
  end

  def install
    system "make", "install-osx", "PREFIX=#{prefix}", "LDFLAGS=", "CFLAGS_EXTRA="
    system "make", "check", "LDFLAGS=", "CFLAGS_EXTRA="
  end
end
