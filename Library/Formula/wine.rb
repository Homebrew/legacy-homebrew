require 'formula'

class Wine < Formula
  homepage 'http://www.winehq.org/'

  if ARGV.flag? '--devel'
    url 'http://downloads.sourceforge.net/project/wine/Source/wine-1.3.17.tar.bz2'
    sha1 'bdad018e266ed3ae8c17c186e435bb775edcc6bf'
  else
    url 'http://downloads.sourceforge.net/project/wine/Source/wine-1.2.2.tar.bz2'
    sha1 '8b37c8e0230dd6a665d310054f4e36dcbdab7330'
  end

  head 'git://source.winehq.org/git/wine.git'

  depends_on 'jpeg'
  depends_on 'libicns'
  depends_on 'gnutls'

  fails_with_llvm

  # the following libraries are currently not specified as dependencies, or not built as 32-bit:
  # configure: libsane, libv4l, libgphoto2, liblcms, gstreamer-0.10, libcapi20, libgsm, libtiff

  # Wine loads many libraries lazily using dlopen calls, so it needs these paths
  # to be searched by dyld.
  # Including /usr/lib because wine, as of 1.3.15, tries to dlopen
  # libncurses.5.4.dylib, and fails to find it without the fallback path.

  def wine_wrapper; <<-EOS
#!/bin/sh
DYLD_FALLBACK_LIBRARY_PATH="/usr/X11/lib:#{HOMEBREW_PREFIX}/lib:/usr/lib" "#{bin}/wine.bin" "$@"
EOS
  end

  def install
    ENV.x11

    # Build 32-bit; Wine doesn't support 64-bit host builds on OS X.
    build32 = "-arch i386 -m32"

    ENV["LIBS"] = "-lGL -lGLU"
    ENV.append "CFLAGS", build32
    ENV.append "CXXFLAGS", "-D_DARWIN_NO_64_BIT_INODE"
    ENV.append "LDFLAGS", "#{build32} -framework CoreServices -lz -lGL -lGLU"

    args = ["--prefix=#{prefix}",
            "--x-include=/usr/X11/include/",
            "--x-lib=/usr/X11/lib/",
            "--with-x",
            "--with-coreaudio",
            "--with-opengl"]
    args << "--disable-win16" if MacOS.leopard?

    # 64-bit builds of mpg123 are incompatible with 32-bit builds of Wine
    args << "--without-mpg123" if Hardware.is_64_bit?

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
