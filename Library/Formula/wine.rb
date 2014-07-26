require 'formula'

# NOTE: When updating Wine, please check Wine-Gecko and Wine-Mono for updates
# too:
#  - http://wiki.winehq.org/Gecko
#  - http://wiki.winehq.org/Mono
class Wine < Formula
  homepage 'http://winehq.org/'

  stable do
    url 'https://downloads.sourceforge.net/project/wine/Source/wine-1.6.2.tar.bz2'
    sha256 'f0ab9eede5a0ccacbf6e50682649f9377b9199e49cf55641f1787cf72405acbe'

    resource 'gecko' do
      url 'https://downloads.sourceforge.net/wine/wine_gecko-2.21-x86.msi', :using => :nounzip
      version '2.21'
      sha1 'a514fc4d53783a586c7880a676c415695fe934a3'
    end

    resource 'mono' do
      url 'https://downloads.sourceforge.net/wine/wine-mono-0.0.8.msi', :using => :nounzip
      sha256 '3dfc23bbc29015e4e538dab8b83cb825d3248a0e5cf3b3318503ee7331115402'
    end
  end

  devel do
    url "https://downloads.sourceforge.net/project/wine/Source/wine-1.7.23.tar.bz2"
    sha256 "db9c7b3b87edde7c63b2c5ae81631771b03650d7435461139fca2b177de05c04"

    # Patch to fix screen-flickering issues. Still relevant on 1.7.23.
    # https://bugs.winehq.org/show_bug.cgi?id=34166
    patch do
      url "https://bugs.winehq.org/attachment.cgi?id=47639"
      sha1 "c195f4b9c0af450c7dc3f396e8661ea5248f2b01"
    end
  end

  head "git://source.winehq.org/git/wine.git"

  env :std

  # note that all wine dependencies should declare a --universal option in their formula,
  # otherwise homebrew will not notice that they are not built universal
  require_universal_deps

  # Wine will build both the Mac and the X11 driver by default, and you can switch
  # between them. But if you really want to build without X11, you can.
  depends_on :x11 => :recommended
  depends_on 'pkg-config' => :build
  depends_on 'freetype'
  depends_on 'jpeg'
  depends_on 'libgphoto2'
  depends_on 'little-cms2'
  depends_on 'libicns'
  depends_on 'libtiff'
  depends_on 'sane-backends'
  depends_on 'libgsm' => :optional

  resource 'gecko' do
    url 'https://downloads.sourceforge.net/wine/wine_gecko-2.24-x86.msi', :using => :nounzip
    version '2.24'
    sha1 'b4923c0565e6cbd20075a0d4119ce3b48424f962'
  end

  resource 'mono' do
    url 'https://downloads.sourceforge.net/wine/wine-mono-4.5.2.msi', :using => :nounzip
    sha256 'd9124edb41ba4418af10eba519dafb25ab4338c567d25ce0eb4ce1e1b4d7eaad'
  end

  fails_with :llvm do
    build 2336
    cause 'llvm-gcc does not respect force_align_arg_pointer'
  end

  fails_with :clang do
    build 425
    cause "Clang prior to Xcode 5 miscompiles some parts of wine"
  end

  # These libraries are not specified as dependencies, or not built as 32-bit:
  # configure: libv4l, gstreamer-0.10, libcapi20, libgsm

  # Wine loads many libraries lazily using dlopen calls, so it needs these paths
  # to be searched by dyld.
  # Including /usr/lib because wine, as of 1.3.15, tries to dlopen
  # libncurses.5.4.dylib, and fails to find it without the fallback path.

  def library_path
    paths = %W[#{HOMEBREW_PREFIX}/lib /usr/lib]
    paths.unshift(MacOS::X11.lib) if build.with? 'x11'
    paths.join(':')
  end

  def wine_wrapper; <<-EOS.undent
    #!/bin/sh
    DYLD_FALLBACK_LIBRARY_PATH="#{library_path}" "#{bin}/wine.bin" "$@"
    EOS
  end

  def install
    # Build 32-bit; Wine doesn't support 64-bit host builds on OS X.
    build32 = "-arch i386 -m32"

    ENV.append "CFLAGS", build32
    ENV.append "LDFLAGS", build32

    # Help configure find libxml2 in an XCode only (no CLT) installation.
    ENV.libxml2

    args = ["--prefix=#{prefix}"]
    args << "--disable-win16" if MacOS.version <= :leopard or ENV.compiler == :clang

    # 64-bit builds of mpg123 are incompatible with 32-bit builds of Wine
    args << "--without-mpg123" if Hardware.is_64_bit?

    args << "--without-x" if build.without? 'x11'

    system "./configure", *args

    unless ENV.compiler == :clang or ENV.compiler == :llvm
      # The Mac driver uses blocks and must be compiled with clang even if the rest of
      # Wine is built with gcc. This must be done after configure.
      system 'make', 'dlls/winemac.drv/Makefile'
      inreplace 'dlls/winemac.drv/Makefile', /^CC\s*=\s*[^\s]+/, "CC = clang"
    end

    system "make install"
    (share/'wine/gecko').install resource('gecko')
    (share/'wine/mono').install resource('mono')

    # Use a wrapper script, so rename wine to wine.bin
    # and name our startup script wine
    mv bin/'wine', bin/'wine.bin'
    (bin/'wine').write(wine_wrapper)

    # Don't need Gnome desktop support
    (share/'applications').rmtree
  end

  def caveats
    s = <<-EOS.undent
      You may want to get winetricks:
        brew install winetricks

      The current version of Wine contains a partial implementation of dwrite.dll
      which may cause text rendering issues in applications such as Steam.
      We recommend that you run winecfg, add an override for dwrite in the
      Libraries tab, and edit the override mode to "disable". See:
        http://bugs.winehq.org/show_bug.cgi?id=31374
    EOS

    if build.with? 'x11'
      s += <<-EOS.undent

        By default Wine uses a native Mac driver. To switch to the X11 driver, use
        regedit to set the "graphics" key under "HKCU\Software\Wine\Drivers" to
        "x11" (or use winetricks).

        For best results with X11, install the latest version of XQuartz:
          http://xquartz.macosforge.org/
      EOS
    end
    return s
  end
end
