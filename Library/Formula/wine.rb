# NOTE: When updating Wine, please check Wine-Gecko and Wine-Mono for updates
# too:
#  - http://wiki.winehq.org/Gecko
#  - http://wiki.winehq.org/Mono
class Wine < Formula
  desc "Wine Is Not an Emulator"
  homepage "https://www.winehq.org/"
  head "git://source.winehq.org/git/wine.git"

  stable do
    url "https://dl.winehq.org/wine/source/1.8/wine-1.8.tar.bz2"
    mirror "https://downloads.sourceforge.net/project/wine/Source/wine-1.8.tar.bz2"
    sha256 "f33b45c18112b2071fbf9edee0e8c575407f9e2a9855ca4ee918ed33efa7c6f4"

    # Patch to fix MSI creation issues.
    # https://bugs.winehq.org/show_bug.cgi?id=40129
    patch do
      url "https://bugs.winehq.org/attachment.cgi?id=53632"
      sha256 "b9f98711cfe62228f5d84ab394394008ee10127bebcea7ef966d24127b466e0a"
    end
  end

  bottle do
    revision 2
    sha256 "33b161d56526335f422f15442da31ab25196556538031ad3fd5825102bb1b484" => :el_capitan
    sha256 "c62a3dd6630de472510be71c50b4724c826dd8daaad9c71bfdb737daa6ccf338" => :yosemite
    sha256 "8bfc2b0d412c8edffde2054f7a42f86545b5466843fabd9e0fcf765f5e428d85" => :mavericks
  end

  devel do
    url "https://dl.winehq.org/wine/source/1.9/wine-1.9.4.tar.bz2"
    mirror "https://downloads.sourceforge.net/project/wine/Source/wine-1.9.4.tar.bz2"
    sha256 "75c1eab6b980870b367a73db6e57eb0dc9242c2be8546f94084577a0ed0bbbb8"
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
  depends_on "gnutls"
  depends_on "libgsm" => :optional
  depends_on "samba" => :optional

  # Patch to fix screen-flickering issues. Still relevant on 1.8.
  # https://bugs.winehq.org/show_bug.cgi?id=34166
  patch do
    url "https://bugs.winehq.org/attachment.cgi?id=52485"
    sha256 "59f1831a1b49c1b7a4c6e6af7e3f89f0bc60bec0bead645a615b251d37d232ac"
  end

  # Patch to fix texture compression issues. Still relevant on 1.8.
  # https://bugs.winehq.org/show_bug.cgi?id=14939
  patch do
    url "https://bugs.winehq.org/attachment.cgi?id=52384"
    sha256 "30766403f5064a115f61de8cacba1defddffe2dd898b59557956400470adc699"
  end

  # This option is currently disabled because Apple clang currently doesn't
  # support a required feature: http://reviews.llvm.org/D1623
  # It builds fine with GCC, however.
  # option "with-win64",
  #        "Build with win64 emulator (won't run 32-bit binaries.)"

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
        # Pass the sysroot to support Xcode-only systems
        cflags  = s.get_make_var("CFLAGS")
        cflags += " --sysroot=#{MacOS.sdk_path}"
        s.change_make_var! "CFLAGS", cflags
      end
    end

    system "make", "install"
    (pkgshare/"gecko").install resource("gecko")
    (pkgshare/"mono").install resource("mono")

    # Use a wrapper script, so rename wine to wine.bin
    # and name our startup script wine
    mv bin/"wine", bin/"wine.bin"
    (bin/"wine").write(wine_wrapper)
  end

  def caveats
    s = <<-EOS.undent
      You may want to get winetricks:
        brew install winetricks
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
