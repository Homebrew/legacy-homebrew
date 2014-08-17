require 'formula'

class Libmpeg2 < Formula
  homepage 'http://libmpeg2.sourceforge.net/'
  url 'http://libmpeg2.sourceforge.net/files/libmpeg2-0.5.1.tar.gz'
  sha1 '0f9163d8fd52db5f577ebe45636f674252641fd7'

  bottle do
    cellar :any
    sha1 "d023c1fcec1355bc1a21cc9e6ab76bf493196dbb" => :mavericks
    sha1 "e7d39e0be6bc10414624e4f04d13b8394295119e" => :mountain_lion
    sha1 "92d3f35c6f9e881e38049b677685cd37225e220a" => :lion
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
