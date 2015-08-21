# NOTE: When updating Wine, please check Wine-Gecko and Wine-Mono for updates
# too:
#  - http://wiki.winehq.org/Gecko
#  - http://wiki.winehq.org/Mono
class Wine < Formula
  desc "Wine Is Not an Emulator"
  homepage "https://www.winehq.org/"

  stable do
    url "https://downloads.sourceforge.net/project/wine/Source/wine-1.6.2.tar.bz2"
    sha256 "f0ab9eede5a0ccacbf6e50682649f9377b9199e49cf55641f1787cf72405acbe"

    resource "gecko" do
      url "https://downloads.sourceforge.net/wine/wine_gecko-2.21-x86.msi", :using => :nounzip
      sha256 "f01fafa6d7aab995c38add77315c4cbc2f32f52d5d6a9350056f42b62d631fd8"
    end

    resource "mono" do
      url "https://downloads.sourceforge.net/wine/wine-mono-0.0.8.msi", :using => :nounzip
      sha256 "3dfc23bbc29015e4e538dab8b83cb825d3248a0e5cf3b3318503ee7331115402"
    end
  end

  bottle do
    sha1 "348f15e19880888d19d04d2fe4bad42048fe6828" => :yosemite
    sha1 "69f05602ecde44875cf26297871186aaa0b26cd7" => :mavericks
    sha1 "a89371854006687b74f4446a52ddb1f68cfafa7e" => :mountain_lion
  end

  devel do
    url "https://downloads.sourceforge.net/project/wine/Source/wine-1.7.50.tar.bz2"
    mirror "http://mirrors.ibiblio.org/wine/source/1.7/wine-1.7.50.tar.bz2"
    sha256 "7c5410fab820281f337d478c18305027363c9012f30f742339ef1eb0f9dd711e"

    depends_on "samba" => :optional
    depends_on "gnutls"

    # Patch to fix screen-flickering issues. Still relevant on 1.7.23.
    # https://bugs.winehq.org/show_bug.cgi?id=34166
    patch do
      url "https://bugs.winehq.org/attachment.cgi?id=47639"
      sha256 "3054467e0b1ef9efce3e1b24497bd26e00c4727e8bd7b1e990d1352bb1819de0"
    end
  end

  head do
    url "git://source.winehq.org/git/wine.git"
    depends_on "samba" => :optional
    option "with-win64",
           "Build with win64 emulator (won't run 32-bit binaries.)"
  end

  # note that all wine dependencies should declare a --universal option in their formula,
  # otherwise homebrew will not notice that they are not built universal
  def require_universal_deps?
    MacOS.prefer_64_bit?
  end

  # Wine will build both the Mac and the X11 driver by default, and you can switch
  # between them. But if you really want to build without X11, you can.
  depends_on :x11 => :recommended
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libgphoto2"
  depends_on "little-cms2"
  depends_on "libicns"
  depends_on "libtiff"
  depends_on "sane-backends"
  depends_on "libgsm" => :optional

  resource "gecko" do
    url "https://downloads.sourceforge.net/wine/wine_gecko-2.40-x86.msi", :using => :nounzip
    sha256 "1a29d17435a52b7663cea6f30a0771f74097962b07031947719bb7b46057d302"
  end

  resource "mono" do
    url "https://downloads.sourceforge.net/wine/wine-mono-4.5.6.msi", :using => :nounzip
    sha256 "ac681f737f83742d786706529eb85f4bc8d6bdddd8dcdfa9e2e336b71973bc25"
  end

  fails_with :llvm do
    build 2336
    cause "llvm-gcc does not respect force_align_arg_pointer"
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
    paths.unshift(MacOS::X11.lib) if build.with? "x11"
    paths.join(":")
  end

  def wine_wrapper; <<-EOS.undent
    #!/bin/sh
    DYLD_FALLBACK_LIBRARY_PATH="#{library_path}" "#{bin}/wine.bin" "$@"
    EOS
  end

  def install
    ENV.m32 # Build 32-bit; Wine doesn't support 64-bit host builds on OS X.

    # Help configure find libxml2 in an XCode only (no CLT) installation.
    ENV.libxml2

    args = ["--prefix=#{prefix}"]
    args << "--disable-win16" if MacOS.version <= :leopard
    args << "--enable-win64" if build.with? "win64"

    # 64-bit builds of mpg123 are incompatible with 32-bit builds of Wine
    args << "--without-mpg123" if Hardware.is_64_bit?

    args << "--without-x" if build.without? "x11"

    system "./configure", *args

    # The Mac driver uses blocks and must be compiled with an Apple compiler
    # even if the rest of Wine is built with A GNU compiler.
    unless ENV.compiler == :clang || ENV.compiler == :llvm || ENV.compiler == :gcc
      system "make", "dlls/winemac.drv/Makefile"
      inreplace "dlls/winemac.drv/Makefile" do |s|
        # We need to use the real compiler, not the superenv shim, which will exec the
        # configured compiler no matter what name is used to invoke it.
        cc = s.get_make_var("CC")
        cxx = s.get_make_var("CXX")
        s.change_make_var! "CC", cc.sub(ENV.cc, "xcrun clang") if cc
        s.change_make_var! "CXX", cc.sub(ENV.cxx, "xcrun clang++") if cxx

        # Emulate some things that superenv would normally handle for us
        # We're configured to use GNU GCC, so remote an unsupported flag
        s.gsub! "-gstabs+", "" if build.stable?
        # Pass the sysroot to support Xcode-only systems
        cflags  = s.get_make_var("CFLAGS")
        cflags += " --sysroot=#{MacOS.sdk_path}"
        s.change_make_var! "CFLAGS", cflags
      end
    end

    system "make", "install"
    (share/"wine/gecko").install resource("gecko")
    (share/"wine/mono").install resource("mono")

    # Use a wrapper script, so rename wine to wine.bin
    # and name our startup script wine
    mv bin/"wine", bin/"wine.bin"
    (bin/"wine").write(wine_wrapper)

    # Don't need Gnome desktop support
    (share/"applications").rmtree
  end

  def caveats
    s = <<-EOS.undent
      You may want to get winetricks:
        brew install winetricks

      The current version of Wine contains a partial implementation of dwrite.dll
      which may cause text rendering issues in applications such as Steam.
      We recommend that you run winecfg, add an override for dwrite in the
      Libraries tab, and edit the override mode to "disable". See:
        https://bugs.winehq.org/show_bug.cgi?id=31374
    EOS

    if build.with? "x11"
      s += <<-EOS.undent

        By default Wine uses a native Mac driver. To switch to the X11 driver, use
        regedit to set the "graphics" key under "HKCU\Software\Wine\Drivers" to
        "x11" (or use winetricks).

        For best results with X11, install the latest version of XQuartz:
          https://xquartz.macosforge.org/
      EOS
    end
    s
  end
end
