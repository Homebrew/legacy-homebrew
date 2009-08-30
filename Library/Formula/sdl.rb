require 'brewkit'

class Sdl <Formula
  @url='http://www.libsdl.org/release/SDL-1.2.13.tar.gz'
  @homepage='http://www.libsdl.org/index.php'
  @md5='c6660feea2a6834de10bc71b2f8e4d88'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
