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
    sha1 "1acad163d4a245f5bd7ad2668cc87a5c9102163a" => :yosemite
    sha1 "2629465c3d063d3a108adc987bbaa910a49db5f4" => :mavericks
    sha1 "b5ccf7ea27f82e7eb8aeed1e327079c8a07434fb" => :mountain_lion
  end

  depends_on :ld64

  cxxstdlib_check :skip

  keg_only :provided_by_osx,
    "This package duplicates tools shipped by Xcode."

  if MacOS.version >= :snow_leopard
    option "with-llvm", "Build with LTO support"
    depends_on "llvm" => :optional

    # These patches apply to cctools 855, for newer OSes
    patch :p0 do
      url "https://trac.macports.org/export/129741/trunk/dports/devel/cctools/files/cctools-829-lto.patch"
      sha256 "8ed90e0eef2a3afc810b375f9d3873d1376e16b17f603466508793647939a868"
    end

    patch :p0 do
      url "https://trac.macports.org/export/129741/trunk/dports/devel/cctools/files/PR-37520.patch"
      sha256 "921cba3546389809500449b08f4275cfd639295ace28661c4f06174b455bf3d4"
    end

    patch :p0 do
      url "https://trac.macports.org/export/129741/trunk/dports/devel/cctools/files/cctools-839-static-dis_info.patch"
      sha256 "f49162b5c5d2753cf19923ff09e90949f01379f8de5604e86c59f67441a1214c"
    end

    # Fix building libtool with LTO disabled
    patch do
      url "https://gist.githubusercontent.com/mistydemeo/9fc5589d568d2fc45fb5/raw/c752d5c4567809c10b14d623b6c2d7416211b33a/libtool-no-lto.diff"
      sha256 "3b687f2b9388ac6c4acac2b7ba28d9fd07f2a16e7d2dad09aa2255d98ec1632b"
    end

    # strnlen patch only needed on Snow Leopard
    if MacOS.version == :snow_leopard
      patch :p0 do
        url "https://trac.macports.org/export/129741/trunk/dports/devel/cctools/files/snowleopard-strnlen.patch"
        sha1 "31c083b056d4510702484436fc66f24cc8635060"
      end
    end
  else
    depends_on "cctools-headers" => :build

    # This set of patches only applies to cctools 806, for older OSes
    patch :p0 do
      url "https://trac.macports.org/export/103959/trunk/dports/devel/cctools/files/cctools-806-lto.patch"
      sha1 "f8a2059a4730119687d2ba6a5d9e7b49b66840e8"
    end

    patch :p0 do
      url "https://trac.macports.org/export/103959/trunk/dports/devel/cctools/files/PR-9087924.patch"
      sha1 "1e5040370944a84e06bd983ea9f4e544a2ea7236"
    end

    patch :p0 do
      url "https://trac.macports.org/export/103959/trunk/dports/devel/cctools/files/PR-9830754.patch"
      sha1 "65b8e2f7a877716fec82fcd2cd0c6c34adfdece3"
    end

    # Despite the patch name this is needed on 806 too
    patch :p0 do
      url "https://trac.macports.org/export/103985/trunk/dports/devel/cctools/files/cctools-822-no-lto.patch"
      sha1 "e58ee836dde4693e90a39579c20df45f067d75a1"
    end

    patch :p0 do
      url "https://trac.macports.org/export/103959/trunk/dports/devel/cctools/files/PR-11136237.patch"
      sha1 "88c045c08161d14241b7d51437b3ba77093d573a"
    end

    patch :p0 do
      url "https://trac.macports.org/export/103959/trunk/dports/devel/cctools/files/PR-12475288.patch"
      sha1 "3d6cb1ff1443b8c1c68c21c9808833537f7ce48d"
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
