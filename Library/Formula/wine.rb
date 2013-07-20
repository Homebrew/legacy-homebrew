require 'formula'

class WineGecko < Formula
  url 'http://downloads.sourceforge.net/wine/wine_gecko-2.21-x86.msi', :using => :nounzip
  sha1 'a514fc4d53783a586c7880a676c415695fe934a3'
end

class WineMono < Formula
  url 'http://downloads.sourceforge.net/wine/wine-mono-0.0.8.msi', :using => :nounzip
  sha1 'dd349e72249ce5ff981be0e9dae33ac4a46a9f60'
end

# NOTE: when updating Wine, please check Wine-Gecko and Wine-Mono for updates
#  http://wiki.winehq.org/Gecko
#  http://wiki.winehq.org/Mono
class Wine < Formula
  homepage 'http://winehq.org/'
  url 'http://downloads.sourceforge.net/project/wine/Source/wine-1.6.tar.bz2'
  sha256 'e1f130efbdcbfa211ca56ee03357ccd17a31443889b4feebdcb88248520b42ae'

  head 'git://source.winehq.org/git/wine.git'

  env :std

  # this tells Homebrew that dependencies must be built universal
  def build.universal? ; true; end

  # note that all wine dependencies should declare a --universal option in their formula,
  # otherwise homebrew will not notice that they are not built universal

  # Wine will build both the Mac and the X11 driver by default, and you can switch
  # between them. But if you really want to build without X11, you can.
  depends_on :x11 => :recommended
  depends_on 'freetype' if build.without? 'x11'
  depends_on 'jpeg'
  depends_on 'libicns'
  depends_on 'libtiff'
  depends_on 'little-cms'
  depends_on 'sane-backends'
  depends_on 'libgphoto2'

  fails_with :llvm do
    build 2336
    cause 'llvm-gcc does not respect force_align_arg_pointer'
  end

  # the following libraries are currently not specified as dependencies, or not built as 32-bit:
  # configure: libv4l, gstreamer-0.10, libcapi20, libgsm

  # Wine loads many libraries lazily using dlopen calls, so it needs these paths
  # to be searched by dyld.
  # Including /usr/lib because wine, as of 1.3.15, tries to dlopen
  # libncurses.5.4.dylib, and fails to find it without the fallback path.

  def wine_wrapper; <<-EOS.undent
    #!/bin/sh
    DYLD_FALLBACK_LIBRARY_PATH="#{MacOS::X11.lib}:#{HOMEBREW_PREFIX}/lib:/usr/lib" "#{bin}/wine.bin" "$@"
    EOS
  end

  def install
    # Build 32-bit; Wine doesn't support 64-bit host builds on OS X.
    build32 = "-arch i386 -m32"

    ENV.append "CFLAGS", build32
    ENV.append "LDFLAGS", build32

    # Still miscompiles at v1.6
    if ENV.compiler == :clang
      opoo <<-EOS.undent
        Clang currently miscompiles some parts of Wine. If you have gcc, you
        can get a more stable build with:
          brew install wine --use-gcc
      EOS
    end

    # Workarounds for XCode not including pkg-config files
    ENV.libxml2
    ENV.append "LDFLAGS", "-lxslt"

    # Note: we get freetype from :x11, but if the freetype formula has been installed
    # separately and not built universal, it's going to get picked up and break the build.
    # We cannot use FREETYPE_LIBS because it is inserted after LDFLAGS and thus cannot
    # take precedence over the homebrew freetype.
    ENV.prepend "LDFLAGS", "-L#{MacOS::X11.lib}" unless build.without? 'x11'

    args = ["--prefix=#{prefix}"]
    args << "--disable-win16" if MacOS.version <= :leopard or ENV.compiler == :clang

    # 64-bit builds of mpg123 are incompatible with 32-bit builds of Wine
    args << "--without-mpg123" if Hardware.is_64_bit?

    system "./configure", *args

    unless ENV.compiler == :clang or ENV.compiler == :llvm
      # The Mac driver uses blocks and must be compiled with clang even if the rest of
      # Wine is built with gcc. This must be done after configure.
      system 'make', 'dlls/winemac.drv/Makefile'
      inreplace 'dlls/winemac.drv/Makefile', /^CC\s*=\s*[^\s]+/, "CC = clang"
    end

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
  end

  def caveats; <<-EOS.undent
    You may want to get winetricks:
      brew install winetricks

    By default Wine uses a native Mac driver. To switch to the X11 driver, use
    regedit to set the "graphics" key under "HKCU\Software\Wine\Drivers" to
    "x11" (or use winetricks).

    For best results with X11, install the latest version of XQuartz:
      http://xquartz.macosforge.org/

    The current version of Wine contains a partial implementation of dwrite.dll
    which may cause text rendering issues in applications such as Steam.
    We recommend that you run winecfg, add an override for dwrite in the
    Libraries tab, and edit the override mode to "disable". See:
      http://bugs.winehq.org/show_bug.cgi?id=31374
    EOS
  end
end
