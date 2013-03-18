require 'formula'

class WineGecko < Formula
  url 'http://downloads.sourceforge.net/wine/wine_gecko-1.4-x86.msi', :using => :nounzip
  sha1 'c30aa99621e98336eb4b7e2074118b8af8ea2ad5'

  devel do
    url 'http://downloads.sourceforge.net/wine/wine_gecko-1.9-x86.msi', :using => :nounzip
    sha1 'd2553224848a926eacfa8685662ff1d7e8be2428'
  end
end

class WineMono < Formula
  url 'http://downloads.sourceforge.net/wine/wine-mono-0.0.8.msi', :using => :nounzip
  sha1 'dd349e72249ce5ff981be0e9dae33ac4a46a9f60'
end

class Wine < Formula
  homepage 'http://winehq.org/'
  url 'http://downloads.sourceforge.net/project/wine/Source/wine-1.4.1.tar.bz2'
  sha256 '3c233e3811e42c2f3623413783dbcd0f2288014b5645211f669ffd0ba6ae1856'

  head 'git://source.winehq.org/git/wine.git'

  devel do
    # NOTE: when updating Wine, please check if Wine-Gecko and Wine-Mono needs
    # updating too
    #  * http://wiki.winehq.org/Gecko
    #  * http://wiki.winehq.org/Mono
    url 'http://downloads.sourceforge.net/project/wine/Source/wine-1.5.26.tar.bz2'
    sha1 '278dd0864468ae1883d2ca605e7468d4d1d4123e'
  end

  env :std

  # this tells Homebrew that dependencies must be built universal
  def build.universal? ; true; end

  depends_on :x11
  # note: we get freetype from :x11, but if the freetype formula has been installed
  # separately and not built universal, it's going to get picked up and break the build
  depends_on 'jpeg'
  depends_on 'libicns'
  depends_on 'libtiff'
  depends_on 'little-cms'

  fails_with :llvm do
    build 2336
    cause 'llvm-gcc does not respect force_align_arg_pointer'
  end

  # Wine tests CFI support by calling clang, but then attempts to use as, which
  # does not work. Use clang for assembling too.
  def patches
    DATA if ENV.compiler == :clang and !build.devel?
  end

  # the following libraries are currently not specified as dependencies, or not built as 32-bit:
  # configure: libsane, libv4l, libgphoto2, gstreamer-0.10, libcapi20, libgsm

  # Wine loads many libraries lazily using dlopen calls, so it needs these paths
  # to be searched by dyld.
  # Including /usr/lib because wine, as of 1.3.15, tries to dlopen
  # libncurses.5.4.dylib, and fails to find it without the fallback path.

  def wine_wrapper; <<-EOS.undent
    #!/bin/sh
    DYLD_FALLBACK_LIBRARY_PATH="#{MacOS::X11.lib}:#{HOMEBREW_PREFIX}/lib:/usr/lib" "#{bin}/wine.bin" "$@"
    EOS
  end

  def winemac_key; <<-EOS.undent
    REGEDIT4
    [HKEY_CURRENT_USER\\Software\\Wine\\Drivers]
    "Graphics"="mac,x11"
    "Ime"="osxime,mac,x11"
    EOS
  end

  def install
    # Build 32-bit; Wine doesn't support 64-bit host builds on OS X.
    build32 = "-arch i386 -m32"

    ENV["LIBS"] = "-lGL -lGLU"
    ENV.append "CFLAGS", build32

    # Still miscompiles at v1.5.25
    if ENV.compiler == :clang
      opoo <<-EOS.undent
        Clang currently miscompiles some parts of Wine. If you have gcc, you
        can get a more stable build with:
          brew install wine --use-gcc
      EOS
    end

    ENV.append "CXXFLAGS", "-D_DARWIN_NO_64_BIT_INODE"
    ENV.append "LDFLAGS", "#{build32} -framework CoreServices -lz -lGL -lGLU"

    # Workarounds for XCode not including pkg-config files
    ENV.libxml2
    ENV.append "LDFLAGS", "-lxslt"

    args = %W[--prefix=#{prefix}
              --with-coreaudio
              --with-opengl
              --with-x
              --x-include=#{MacOS::X11.include}
              --x-lib=#{MacOS::X11.lib}]
    args << "--disable-win16" if MacOS.version == :leopard or ENV.compiler == :clang

    # 64-bit builds of mpg123 are incompatible with 32-bit builds of Wine
    args << "--without-mpg123" if Hardware.is_64_bit?

    system "./configure", *args
    system "make install"

    # Don't need Gnome desktop support
    rm_rf share+'applications'

    # Download Gecko and Mono once so we don't need to redownload for each prefix
    gecko = WineGecko.new
    gecko.brew { (share+'wine/gecko').install Dir["*"] }
    mono = WineMono.new
    mono.brew { (share+'wine/mono').install Dir["*"] }

    # Use a wrapper script, so rename wine to wine.bin
    # and name our startup script wine
    mv bin/'wine', bin/'wine.bin'
    (bin/'wine').write(wine_wrapper)

    (prefix/'winemac.key').write(winemac_key) unless build.stable?
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
    unless build.stable?
      # see http://bugs.winehq.org/show_bug.cgi?id=31374
      s += <<-EOS.undent

        The current version of Wine contains a partial implementation of dwrite.dll
        which may cause text rendering issues in applications such as Steam.
        We recommend that you run winecfg, add an override for dwrite in the
        Libraries tab, and edit the override mode to "disable".
      EOS
      s += <<-EOS.undent

        Starting with wine 1.5.22 the new experimental Mac driver by CodeWeavers has
        been included in the main distribution. This allows wine to run without X11
        on MacOS X. To enable it execute the following command in your wine prefix:

          wine regedit #{prefix/'winemac.key'}

        To disable it execute:

          wine regedit /D 'HKEY_CURRENT_USER\\Software\\Wine\\Drivers'
      EOS
    end
    return s
  end
end

__END__
diff --git a/tools/winebuild/utils.c b/tools/winebuild/utils.c
index 09f9b73..ed198f8 100644
--- a/tools/winebuild/utils.c
+++ b/tools/winebuild/utils.c
@@ -345,10 +345,11 @@ struct strarray *get_as_command(void)
 
     if (!as_command)
     {
-        static const char * const commands[] = { "gas", "as", NULL };
-        as_command = find_tool( "as", commands );
+        static const char * const commands[] = { "clang", NULL };
+        as_command = find_tool( "clang", commands );
     }
     strarray_add_one( args, as_command );
+    strarray_add_one( args, "-c" );
 
     if (force_pointer_size)
     {
