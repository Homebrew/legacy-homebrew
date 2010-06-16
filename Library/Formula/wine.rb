require 'formula'

class Wine <Formula
  url 'http://downloads.sourceforge.net/project/wine/Source/wine-1.1.42.tar.bz2'
  sha1 'ea932f19528a22eacc49f16100dbf2251cb4ad5c'
  homepage 'http://www.winehq.org/'
  head 'git://source.winehq.org/git/wine.git'

  depends_on 'jpeg'
  depends_on 'mpg123' => :optional

  def wine_wrapper; <<-EOS
#!/bin/sh
DYLD_FALLBACK_LIBRARY_PATH="/usr/X11/lib" \
"#{bin}/wine.bin" "$@"
EOS
  end

  def install
    fails_with_llvm
    ENV.x11

    # Make sure we build 32bit version, because Wine64 is not fully functional yet
    build32 = "-arch i386 -m32"

    ENV["LIBS"] = "-lGL -lGLU"
    ENV.append "CFLAGS", build32
    ENV.append "CXXFLAGS", "-D_DARWIN_NO_64_BIT_INODE"
    ENV.append "LDFLAGS", [build32, "-framework CoreServices", "-lz", "-lGL -lGLU"].join(' ')
    ENV.append "DYLD_FALLBACK_LIBRARY_PATH", "/usr/X11/lib"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-win16"
    system "make install"

    # Use a wrapper script, so rename wine to wine.bin
    # and name our startup script wine
    mv (bin+'wine'), (bin+'wine.bin')
    (bin+'wine').write(wine_wrapper)
  end

  def caveats
    <<-EOS.undent
      You may also want to get winetricks:
        brew install winetricks
    EOS
  end
end
