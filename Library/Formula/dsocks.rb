class Dsocks < Formula
  desc "SOCKS client wrapper for *BSD/OS X"
  homepage "http://monkey.org/~dugsong/dsocks/"
  url "https://dsocks.googlecode.com/files/dsocks-1.8.tar.gz"
  sha256 "2b57fb487633f6d8b002f7fe1755480ae864c5e854e88b619329d9f51c980f1d"

  bottle do
    cellar :any
    sha256 "9b764e48bfe348433382d030a4aa00eefe1afa63b6bcfaab2450101bb429020e" => :el_capitan
    sha256 "d537e7fe450742d499835b2ba76a94df1285162709b7d953530d5814a0f78019" => :yosemite
    sha256 "419d972f1aba39997ec90a4c8e35c98ecfedbfb63506478e8b406ac04a01e5de" => :mavericks
  end

  def install
    system ENV.cc, ENV.cflags, "-shared", "-o", "libdsocks.dylib", "dsocks.c", "atomicio.c", "-lresolv"
    inreplace "dsocks.sh", "/usr/local", HOMEBREW_PREFIX

    lib.install "libdsocks.dylib"
    bin.install "dsocks.sh"
  end
end
