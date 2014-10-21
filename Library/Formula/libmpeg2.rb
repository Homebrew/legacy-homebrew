require 'formula'

class Libmpeg2 < Formula
  homepage 'http://libmpeg2.sourceforge.net/'
  url 'http://libmpeg2.sourceforge.net/files/libmpeg2-0.5.1.tar.gz'
  sha1 '0f9163d8fd52db5f577ebe45636f674252641fd7'

  bottle do
    cellar :any
    revision 1
    sha1 "39cdc686342af5981a71b97ac6c1682b5faf547c" => :yosemite
    sha1 "24e079241e46a6bad3527ea0662cb79b8c74260c" => :mavericks
    sha1 "6e13bb1b550c921c749cacf50792efdd2f6a8903" => :mountain_lion
  end

  depends_on 'sdl'

  def install
    # Otherwise compilation fails in clang with `duplicate symbol ___sputc`
    ENV.append_to_cflags '-std=gnu89'

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
