require 'brewkit'

class Sdl <Formula
  @url='http://www.libsdl.org/release/SDL-1.2.13.tar.gz'
  @homepage='http://www.libsdl.org/index.php'
  @md5='c6660feea2a6834de10bc71b2f8e4d88'

  def patches
    { :p0 => "http://methylblue.com/junk/libsdl-1.2.13-10.6.patch" }
  end

  def install
    ENV.gcc_4_2
    system "./configure", "--prefix=#{prefix}", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-video-x11",
                          "--disable-nasm"
    system "make install"
    
    # Copy source files needed for Ojective-C support.
    libexec.install Dir["src/main/macosx/*"]
  end
end
