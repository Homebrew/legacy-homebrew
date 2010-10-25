require 'formula'

class Wine <Formula
  url 'http://downloads.sourceforge.net/project/wine/Source/wine-1.2.1.tar.bz2'
  sha1 '02df427698de8a6d937e722923c8ac1cf886ca27'
  homepage 'http://www.winehq.org/'
  head 'git://source.winehq.org/git/wine.git'

  depends_on 'jpeg'

  # This is required for using 3D applications.
  def wine_wrapper; <<-EOS
#!/bin/sh
DYLD_FALLBACK_LIBRARY_PATH="/usr/X11/lib" "#{bin}/wine.bin" "$@"
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

    args = ["--prefix=#{prefix}", "--x-include=/usr/X11/include/", "--x-lib=/usr/X11/lib/"]
    args << "--without-freetype" if snow_leopard_64?
    args << "--disable-win16" if MACOS_VERSION < 10.6

    if Hardware.is_64_bit? and Formula.factory('mpg123').installed?
      opoo "A 64-bit mpg123 causes this formula to fail"
      puts <<-EOS.undent
        Because Wine builds 32-bit, a 64-bit mpg123 will cause this formula to fail.
        You can get around this by doing `brew unlink mpg123` before installing Wine
        and then `brew link mpg123` afterwards.
      EOS
    end

    system "./configure", *args
    system "make install"

    # Don't need Gnome desktop support
    rm_rf share+'applications'

    # Use a wrapper script, so rename wine to wine.bin
    # and name our startup script wine
    mv (bin+'wine'), (bin+'wine.bin')
    (bin+'wine').write(wine_wrapper)
  end

  def caveats; <<-EOS.undent
    For a more full-featured install, try:
      http://code.google.com/p/osxwinebuilder/

    You may also want to get winetricks:
      brew install winetricks

    To use 3D applications, like games, check "Emulate a virtual desktop" in
    winecfg's "Graphics" tab.
    EOS
  end
end
