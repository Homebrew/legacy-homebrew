require 'formula'

class WineGecko < Formula
  url 'http://downloads.sourceforge.net/wine/wine_gecko-1.4-x86.msi', :using => :nounzip
  sha1 'c30aa99621e98336eb4b7e2074118b8af8ea2ad5'
end

class WineGeckoOld < Formula
  url 'http://downloads.sourceforge.net/wine/wine_gecko-1.0.0-x86.cab', :using => :nounzip
  sha1 'afa22c52bca4ca77dcb9edb3c9936eb23793de01'
end

class Wine < Formula
  homepage 'http://winehq.org/'
  url 'http://downloads.sourceforge.net/project/wine/Source/wine-1.2.3.tar.bz2'
  sha256 '3fd8d3f2b466d07eb90b8198cdc9ec3005917a4533db7b8c6c69058a2e57c61f'
  head 'git://source.winehq.org/git/wine.git'

  devel do
    url 'http://downloads.sourceforge.net/project/wine/Source/wine-1.4-rc4.tar.bz2'
    sha256 '3105c4f7e0a3c326c3dc82257b6af96dd5db6cc2afbe4b8a936563d2da04d1ec'
  end

  depends_on 'jpeg'
  depends_on 'libicns'

  # gnutls not needed since 1.3.16
  depends_on 'gnutls' unless ARGV.build_devel? or ARGV.build_head?

  fails_with_llvm 'llvm-gcc does not respect force_align_arg_pointer', :build => 2336

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
    ENV.O1 if ENV.compiler == :clang
    ENV.append "CXXFLAGS", "-D_DARWIN_NO_64_BIT_INODE"
    ENV.append "LDFLAGS", "#{build32} -framework CoreServices -lz -lGL -lGLU"

    args = ["--prefix=#{prefix}",
            "--x-include=/usr/X11/include/",
            "--x-lib=/usr/X11/lib/",
            "--with-x",
            "--with-coreaudio",
            "--with-opengl"]
    args << "--disable-win16" if MacOS.leopard? or ENV.compiler == :clang

    # 64-bit builds of mpg123 are incompatible with 32-bit builds of Wine
    args << "--without-mpg123" if Hardware.is_64_bit?

    system "./configure", *args
    system "make install"

    # Don't need Gnome desktop support
    rm_rf share+'applications'

    # Download Gecko once so we don't need to redownload for each prefix
    gecko = (ARGV.build_devel? or ARGV.build_head?) ? WineGecko.new : WineGeckoOld.new
    gecko.brew { (share+'wine/gecko').install Dir["*"] }

    # Use a wrapper script, so rename wine to wine.bin
    # and name our startup script wine
    mv (bin+'wine'), (bin+'wine.bin')
    (bin+'wine').write(wine_wrapper)
  end

  def patches
    p = []
    # There is a bug in the Lion version of ld that prevents Wine from building
    # correctly; see <http://bugs.winehq.org/show_bug.cgi?id=27929>
    # We have backported Camillo Lugaresi's patch from upstream. The patch can
    # be removed from this formula once it lands in both the devel and stable
    # branches of Wine.
    p << DATA if MacOS.lion? and not (ARGV.build_devel? or ARGV.build_head?)

    # Wine tests CFI support by calling clang, but then attempts to use as, which
    # does not work. Use clang for assembling too.
    p << 'https://raw.github.com/gist/1755988/266f883f568c223ab25da08581c1a08c47bb770f/winebuild.patch' if ENV.compiler == :clang
    p
  end

  def caveats
    s = <<-EOS.undent
      For best results, you will want to install the latest version of XQuartz:
        http://xquartz.macosforge.org/

      You may also want to get winetricks:
        brew install winetricks

      Or check out:
        http://code.google.com/p/osxwinebuilder/
    EOS
    if not (ARGV.build_devel? or ARGV.build_head?)
      s += <<-EOS.undent

        The stable version of Wine is very old. You will get better results with
        the development version. Use:
          brew install wine --devel
      EOS
    end
    return s
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
