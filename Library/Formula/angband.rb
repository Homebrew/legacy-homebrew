require 'brewkit'

class Angband <Formula
  @url='http://rephial.org/downloads/3.0/angband-3.0.9b-src.tar.gz'
  @md5='51a24fe3119e7eff8a8395d601b2747e'
  @homepage='http://rephial.org/'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-curses",
                          "--disable-x11",
                          "--disable-sdltest",
                          "--with-libpath=#{libexec}"
    system "make"
    # Install manually; 'make install' doesn't work.
    bin.install "src/angband"
    libexec.install Dir['lib/*']
  end
end
