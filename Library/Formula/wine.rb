require 'formula'

class WineGecko < Formula
  url 'http://downloads.sourceforge.net/wine/wine_gecko-1.2.0-x86.msi', :using => :nounzip
  sha1 '6964d1877668ab7da07a60f6dcf23fb0e261a808'
end

class WineGeckoOld < Formula
  url 'http://downloads.sourceforge.net/wine/wine_gecko-1.0.0-x86.cab', :using => :nounzip
  sha1 'afa22c52bca4ca77dcb9edb3c9936eb23793de01'
end

class Wine < Formula
  homepage 'http://winehq.org/'

  if ARGV.flag? '--devel'
    url 'http://downloads.sourceforge.net/project/wine/Source/wine-1.3.30.tar.bz2'
    sha256 '05edc5b5a214edf6f1d0a3a7f6e2cdbace7d261763b41d832d62b6d3872a543e'
  else
    url 'http://downloads.sourceforge.net/project/wine/Source/wine-1.2.3.tar.bz2'
    sha256 '3fd8d3f2b466d07eb90b8198cdc9ec3005917a4533db7b8c6c69058a2e57c61f'
  end

  head 'git://source.winehq.org/git/wine.git'

  depends_on 'jpeg'
  depends_on 'libicns'

  # gnutls not needed since 1.3.16
  depends_on 'gnutls' unless ARGV.flag? '--devel' or ARGV.build_head?

  fails_with_llvm 'Wine dies with an "Unhandled exception code" when built with LLVM'

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

    # Download Gecko once so we don't need to redownload for each prefix
    gecko = (ARGV.flag? '--devel') ? WineGecko.new : WineGeckoOld.new
    gecko.brew { (share+'wine/gecko').install Dir["*"] }

    # Use a wrapper script, so rename wine to wine.bin
    # and name our startup script wine
    mv (bin+'wine'), (bin+'wine.bin')
    (bin+'wine').write(wine_wrapper)
  end

  # There is a bug in the Lion version of ld that prevents Wine from building
  # correctly; see <http://bugs.winehq.org/show_bug.cgi?id=27929>
  # We have backported Camillo Lugaresi's patch from upstream. The patch can
  # be removed from this formula once it lands in both the devel and stable
  # branches of Wine.
  if MacOS.lion? and not (ARGV.flag? '--devel' or ARGV.build_head?)
    def patches; DATA; end
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


__END__
diff --git a/configure b/configure
index e8bc505..4b9a6d4 100755
--- a/configure
+++ b/configure
@@ -6417,7 +6417,7 @@ fi
 
     APPLICATIONSERVICESLIB="-framework ApplicationServices"
 
-    LDEXECFLAGS="-image_base 0x7bf00000 -Wl,-segaddr,WINE_DOS,0x00000000,-segaddr,WINE_SHAREDHEAP,0x7f000000"
+    LDEXECFLAGS="-image_base 0x7bf00000 -Wl,-macosx_version_min,10.6,-segaddr,WINE_DOS,0x00000000,-segaddr,WINE_SHAREDHEAP,0x7f000000"
 
     if test "$ac_cv_header_DiskArbitration_DiskArbitration_h" = "yes"
     then
