class Ftgl < Formula
  desc "Freetype / OpenGL bridge"
  homepage "https://sourceforge.net/projects/ftgl/"
  url "https://downloads.sourceforge.net/project/ftgl/FTGL%20Source/2.1.3~rc5/ftgl-2.1.3-rc5.tar.gz"
  sha256 "5458d62122454869572d39f8aa85745fc05d5518001bcefa63bd6cbb8d26565b"

  bottle do
    cellar :any
    sha256 "6462eb0b97ab120639f1a191f6e3a39419bbb813abd71f5c741303dbf0aed7fb" => :el_capitan
    sha256 "26db05485600adfb7ead23d04fae9b1ee1d1a4b7ac304e1453ad83b4b2c39f64" => :yosemite
    sha256 "50a41f3c95a363b52bc367abf4b5b9dc272d71c8b35fe8e63f058c7cf7162225" => :mavericks
  end

  depends_on "freetype"

  def install
    # If doxygen is installed, the docs may still fail to build.
    # So we disable building docs.
    inreplace "configure", "set dummy doxygen;", "set dummy no_doxygen;"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-freetypetest",
                          # Skip building the example program by failing to find GLUT (MacPorts)
                          "--with-glut-inc=/dev/null",
                          "--with-glut-lib=/dev/null"

    system "make", "install"
  end
end
