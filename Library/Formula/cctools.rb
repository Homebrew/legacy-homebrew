class Cctools < Formula
  desc "Binary and cross-compilation tools for Apple"
  homepage "https://opensource.apple.com/"

  if MacOS.version >= :snow_leopard
    url "https://opensource.apple.com/tarballs/cctools/cctools-855.tar.gz"
    sha1 "b6997939aa9f4f3c4ac70ec819e719330dcd7bcb"
  else
    # 806 (from Xcode 4.1) is the latest version that supports Tiger or PowerPC
    url "https://opensource.apple.com/tarballs/cctools/cctools-806.tar.gz"
    sha1 "e4f9a7ee0eef930e81d50b6b7300b8ddc1c7b341"
  end

  bottle do
    cellar :any
    sha1 "1acad163d4a245f5bd7ad2668cc87a5c9102163a" => :yosemite
    sha1 "2629465c3d063d3a108adc987bbaa910a49db5f4" => :mavericks
    sha1 "b5ccf7ea27f82e7eb8aeed1e327079c8a07434fb" => :mountain_lion
  end

  depends_on :ld64

  keg_only :provided_by_osx,
    "This package duplicates tools shipped by Xcode."

  if MacOS.version >= :snow_leopard
    option "with-llvm", "Build with LTO support"
    depends_on "llvm" => :optional

    # These patches apply to cctools 855, for newer OSes
    patch :p0 do
      url "https://trac.macports.org/export/129741/trunk/dports/devel/cctools/files/cctools-829-lto.patch"
      sha1 "b774fb58dbc0e1b5ad9c6a5d6e35d4207018a338"
    end

    patch :p0 do
      url "https://trac.macports.org/export/129741/trunk/dports/devel/cctools/files/PR-37520.patch"
      sha1 "338faf38ee7eca09185f6eab30cc01b0ad2253ae"
    end

    patch :p0 do
      url "https://trac.macports.org/export/129741/trunk/dports/devel/cctools/files/cctools-839-static-dis_info.patch"
      sha1 "125b42ddc081b70d1ef03a340feb1e827eb36cea"
    end

    # Fix building libtool with LTO disabled
    patch do
      url "https://gist.githubusercontent.com/mistydemeo/9fc5589d568d2fc45fb5/raw/c752d5c4567809c10b14d623b6c2d7416211b33a/libtool-no-lto.diff"
      sha1 "f4750ffad99d034e874972e67e57841dd4225065"
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
    assert shell_output("#{bin}/otool -L #{bin}/install_name_tool").include? "/usr/lib/libSystem.B.dylib"
  end
end
