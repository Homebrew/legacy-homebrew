require 'formula'

class Wine <Formula
  url 'http://downloads.sourceforge.net/project/wine/Source/wine-1.1.44.tar.bz2'
  sha1 '60f11693161b28ff9814949f2b6bbccee1d07a2c'
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

    # Build 32-bit; Wine doesn't support 64-bit host builds on OS X.
    build32 = "-arch i386 -m32"

    ENV["LIBS"] = "-lGL -lGLU"
    ENV.append "CFLAGS", build32
    ENV.append "CXXFLAGS", "-D_DARWIN_NO_64_BIT_INODE"
    ENV.append "LDFLAGS", "#{build32} -framework CoreServices -lz -lGL -lGLU"
    ENV.append "DYLD_FALLBACK_LIBRARY_PATH", "/usr/X11/lib"

    args = [ "--prefix=#{prefix}", "--disable-win16" ]

    # Building a universal mpg123 is non-trivial, so skip for now.
    args << "--without-mpg123" if Hardware.is_64_bit? and MACOS_VERSION >= 10.6

    system "./configure", *args
    system "make install"

    # Don't need Gnome desktop support
    rm_rf share+'applications'

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
