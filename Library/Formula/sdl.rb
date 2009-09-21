require 'brewkit'

class Sdl <Formula
  @url='http://www.libsdl.org/release/SDL-1.2.13.tar.gz'
  @homepage='http://www.libsdl.org/index.php'
  @md5='c6660feea2a6834de10bc71b2f8e4d88'

  def patches
    { :p0 => "http://methylblue.com/junk/libsdl-1.2.13-10.6.patch" }
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-video-x11",
                          "--disable-nasm" # seems essential to build on 10.6
    system "make install"
  end
end
