class Libmpeg2 < Formula
  desc "Library to decode mpeg-2 and mpeg-1 video streams"
  homepage "http://libmpeg2.sourceforge.net/"
  url "http://libmpeg2.sourceforge.net/files/libmpeg2-0.5.1.tar.gz"
  sha256 "dee22e893cb5fc2b2b6ebd60b88478ab8556cb3b93f9a0d7ce8f3b61851871d4"

  bottle do
    cellar :any
    revision 1
    sha256 "841e93dd99b97b96b475aedff29b58f5be5c4156869b1c0212e5d7ed8dd7f481" => :el_capitan
    sha1 "39cdc686342af5981a71b97ac6c1682b5faf547c" => :yosemite
    sha1 "24e079241e46a6bad3527ea0662cb79b8c74260c" => :mavericks
    sha1 "6e13bb1b550c921c749cacf50792efdd2f6a8903" => :mountain_lion
  end

  depends_on "sdl"

  def install
    # Otherwise compilation fails in clang with `duplicate symbol ___sputc`
    ENV.append_to_cflags "-std=gnu89"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
