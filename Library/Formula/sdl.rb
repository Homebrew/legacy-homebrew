require 'formula'

class Sdl <Formula
  url 'http://www.libsdl.org/release/SDL-1.2.14.tar.gz'
  homepage 'http://www.libsdl.org/'
  md5 'e52086d1b508fa0b76c52ee30b55bec4'

  def install
    ENV.gcc_4_2
    system "./configure", "--prefix=#{prefix}", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-nasm"
    system "make install"
    
    # Copy source files needed for Ojective-C support.
    libexec.install Dir["src/main/macosx/*"]
  end
end
