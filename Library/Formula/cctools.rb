class Cctools < Formula
  desc "Binary and cross-compilation tools for Apple"
  homepage "https://opensource.apple.com/"

  if MacOS.version >= :snow_leopard
    url "https://opensource.apple.com/tarballs/cctools/cctools-855.tar.gz"
    sha256 "751748ddf32c8ea84c175f32792721fa44424dad6acbf163f84f41e9617dbc58"
  else
    # 806 (from Xcode 4.1) is the latest version that supports Tiger or PowerPC
    url "https://opensource.apple.com/tarballs/cctools/cctools-806.tar.gz"
    sha256 "6116c06920112c634f6df2fa8b2f171ee3b90ff2176137da5856336695a6a676"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "398333f85c3944de889172ca9d3aa5ffd709403ca2225316f130be817f09873a" => :el_capitan
    sha256 "a76a710f5f164feace5ad107eb40bf5e6a25e916f7334e69ee197a8e3d02b90c" => :yosemite
    sha256 "3b0c895c6f0832ef9509720ebc15478e188ea6396ba41729273eb64d7b2f7ec2" => :mavericks
    sha256 "f9f74d98119d2efd5530f8d98eb7838a77be35576880ecec73fe9d535aa2afb0" => :mountain_lion
  end

  keg_only :provided_by_osx,
    "This package duplicates tools shipped by Xcode."

  depends_on :ld64

  cxxstdlib_check :skip

  if MacOS.version >= :snow_leopard
    option "with-llvm", "Build with LTO support"
    depends_on "llvm" => :optional

    # These patches apply to cctools 855, for newer OSes
    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/patches/db27850/cctools/cctools-829-lto.patch"
      sha256 "8ed90e0eef2a3afc810b375f9d3873d1376e16b17f603466508793647939a868"
    end

    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/patches/db27850/cctools/PR-37520.patch"
      sha256 "921cba3546389809500449b08f4275cfd639295ace28661c4f06174b455bf3d4"
    end

    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/patches/db27850/cctools/cctools-839-static-dis_info.patch"
      sha256 "f49162b5c5d2753cf19923ff09e90949f01379f8de5604e86c59f67441a1214c"
    end

    # Fix building libtool with LTO disabled
    patch do
      url "https://raw.githubusercontent.com/Homebrew/patches/db27850/cctools/libtool-no-lto.diff"
      sha256 "3b687f2b9388ac6c4acac2b7ba28d9fd07f2a16e7d2dad09aa2255d98ec1632b"
    end

    # strnlen patch only needed on Snow Leopard
    if MacOS.version == :snow_leopard
      patch :p0 do
        url "https://raw.githubusercontent.com/Homebrew/patches/db27850/cctools/snowleopard-strnlen.patch"
        sha256 "b118f94411ad194596102f230abafa2f20262343ab36f2a578c6bdc1ae83ae12"
      end
    end
  else
    depends_on "cctools-headers" => :build

    # This set of patches only applies to cctools 806, for older OSes
    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/patches/db27850/cctools/cctools-806-lto.patch"
      sha256 "a92f38f0c34749b0988d4bfec77dec3ce3fc27d50a2cf9f3aaffa4277386470c"
    end

    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/patches/db27850/cctools/PR-9087924.patch"
      sha256 "6020933a25196660c2eb09d06f2cc4c2b5d67158fd2d99c221a17b63111ff391"
    end

    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/patches/db27850/cctools/PR-9830754.patch"
      sha256 "092e2762328477227f9589adf14c14945ebe6f266567deef16754ccc2ecb352d"
    end

    # Despite the patch name this is needed on 806 too
    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/patches/db27850/cctools/cctools-822-no-lto.patch"
      sha256 "535fe18d8842b03d23b0be057905f4f685d63b9c6436227b623b7aecd8e6ea83"
    end

    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/patches/db27850/cctools/PR-11136237.patch"
      sha256 "a19685c8870bdf270ed0fb8240985d87556be07eef14920ea782e2f5ec076759"
    end

    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/patches/db27850/cctools/PR-12475288.patch"
      sha256 "2883e782094e05cbe5bc5a9f672aa775bc23ca0c77d2ecaa931be8b39e3525cb"
    end
  end

  def install
    ENV.j1 # see https://github.com/mistydemeo/tigerbrew/issues/102

    if build.with? "llvm"
      inreplace "libstuff/lto.c", "@@LLVM_LIBDIR@@", Formula["llvm"].opt_lib
    end

    args = %W[
      RC_ProjectSourceVersion=#{version}
      USE_DEPENDENCY_FILE=NO
      BUILD_DYLIBS=NO
      CC=#{ENV.cc}
      CXX=#{ENV.cxx}
      LTO=#{"-DLTO_SUPPORT" if build.with? "llvm"}
      RC_CFLAGS=#{ENV.cflags}
      TRIE=
      RC_OS="macos"
      DSTROOT=#{prefix}
    ]

    # Fixes build with gcc-4.2: https://trac.macports.org/ticket/43745
    args << "SDK=-std=gnu99"

    if Hardware::CPU.intel?
      archs = "i386 x86_64"
    else
      archs = "ppc i386 x86_64"
    end
    args << "RC_ARCHS=#{archs}"

    system "make", "install_tools", *args

    # cctools installs into a /-style prefix in the supplied DSTROOT,
    # so need to move the files into the standard paths.
    # Also merge the /usr and /usr/local trees.
    man.install Dir["#{prefix}/usr/local/man/*"]
    prefix.install Dir["#{prefix}/usr/local/*"]
    bin.install Dir["#{prefix}/usr/bin/*"]
    (include/"mach-o").install Dir["#{prefix}/usr/include/mach-o/*"]
    man1.install Dir["#{prefix}/usr/share/man/man1/*"]
    man3.install Dir["#{prefix}/usr/share/man/man3/*"]
    man5.install Dir["#{prefix}/usr/share/man/man5/*"]

    # These install locations changed between 806 and 855
    if MacOS.version >= :snow_leopard
      (libexec/"as").install Dir["#{prefix}/usr/libexec/as/*"]
    else
      (libexec/"gcc/darwin").install Dir["#{prefix}/usr/libexec/gcc/darwin/*"]
      share.install Dir["#{prefix}/usr/share/gprof.*"]
    end
  end

  def caveats; <<-EOS.undent
    cctools's version of ld was not built.
    EOS
  end

  test do
    assert_match "/usr/lib/libSystem.B.dylib", shell_output("#{bin}/otool -L #{bin}/install_name_tool")
  end
end
