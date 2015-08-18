class Hhvm < Formula
  desc "JIT compiler and runtime for the PHP and Hack languages"
  homepage "http://hhvm.com/"
  url "http://dl.hhvm.com/source/hhvm-3.9.0.tar.bz2"
  sha256 "99e6e04c88e09442be5c40fd74e9eb2d816b9adfd94c76c30ed9ae1587198503"

  head "https://github.com/facebook/hhvm.git"

  option "with-debug", <<-EOS.undent
    Make an unoptimized build with assertions enabled. This will run PHP and
    Hack code dramatically slower than a release build, and is suitable mostly
    for debugging HHVM itself.
  EOS

  # Needs libdispatch APIs only available in Mavericks and newer.
  depends_on :macos => :mavericks

  # We need to build with upstream clang -- the version Apple ships doesn't
  # support TLS, which HHVM uses heavily. (And gcc compiles HHVM fine, but
  # causes ld to trip an assert and fail, for unclear reasons.)
  depends_on "llvm" => [:build, "with-clang"]

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "dwarfutils" => :build
  depends_on "gawk" => :build
  depends_on "libelf" => :build
  depends_on "libtool" => :build
  depends_on "md5sha1sum" => :build
  depends_on "ocaml" => :build
  depends_on "pkg-config" => :build

  depends_on "boost"
  depends_on "freetype"
  depends_on "gd"
  depends_on "gettext"
  depends_on "glog"
  depends_on "gmp"
  depends_on "icu4c"
  depends_on "imagemagick"
  depends_on "jemalloc"
  depends_on "jpeg"
  depends_on "libevent"
  depends_on "libmemcached"
  depends_on "libpng"
  depends_on "mcrypt"
  depends_on "oniguruma"
  depends_on "openssl"
  depends_on "readline"
  depends_on "sqlite"
  depends_on "tbb"

  def install
    # Work around https://github.com/Homebrew/homebrew/issues/42957 by making
    # brew's superenv forget which libraries it wants to inject into ld
    # invocations. (We tell cmake below where they all are, so we don't need
    # them to be injected like that.)
    ENV["HOMEBREW_LIBRARY_PATHS"] = ""

    # Features which don't work on OS X yet since they haven't been ported yet.
    cmake_args = %W[
      -DENABLE_MCROUTER=OFF
      -DENABLE_EXTENSION_MCROUTER=OFF
    ]

    # Required to specify a socket path if you are using the bundled async SQL
    # client (which is very strongly recommended).
    cmake_args << "-DMYSQL_UNIX_SOCK_ADDR=/tmp/mysql.sock"

    # We tell HHVM below where readline is, but due to the machinery of CMake's
    # subprojects, it's hard for HHVM to tell one of its subproject dependencies
    # where readline is, so be more aggressive in a way that makes it through.
    cmake_args << "-DCMAKE_C_FLAGS=-I#{Formula["readline"].opt_include} -L#{Formula["readline"].opt_lib}"
    cmake_args << "-DCMAKE_CXX_FLAGS=-I#{Formula["readline"].opt_include} -L#{Formula["readline"].opt_lib}"

    # Dependency information.
    cmake_args += %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_CXX_COMPILER=#{Formula["llvm"].opt_bin}/clang++
      -DCMAKE_C_COMPILER=#{Formula["llvm"].opt_bin}/clang
      -DCMAKE_ASM_COMPILER=#{Formula["llvm"].opt_bin}/clang
      -DLIBEVENT_INCLUDE_DIR=#{Formula["libevent"].opt_include}
      -DLIBEVENT_LIB=#{Formula["libevent"].opt_lib}/libevent.dylib
      -DICU_INCLUDE_DIR=#{Formula["icu4c"].opt_include}
      -DICU_LIBRARY=#{Formula["icu4c"].opt_lib}/libicuuc.dylib
      -DICU_I18N_LIBRARY=#{Formula["icu4c"].opt_lib}/libicui18n.dylib
      -DICU_DATA_LIBRARY=#{Formula["icu4c"].opt_lib}/libicudata.dylib
      -DREADLINE_INCLUDE_DIR=#{Formula["readline"].opt_include}
      -DREADLINE_LIBRARY=#{Formula["readline"].opt_lib}/libreadline.dylib
      -DBOOST_INCLUDEDIR=#{Formula["boost"].opt_include}
      -DBOOST_LIBRARYDIR=#{Formula["boost"].opt_lib}
      -DJEMALLOC_INCLUDE_DIR=#{Formula["jemalloc"].opt_include}
      -DJEMALLOC_LIB=#{Formula["jemalloc"].opt_lib}/libjemalloc.dylib
      -DLIBINTL_INCLUDE_DIR=#{Formula["gettext"].opt_include}
      -DLIBINTL_LIBRARIES=#{Formula["gettext"].opt_lib}/libintl.dylib
      -DLIBDWARF_INCLUDE_DIRS=#{Formula["dwarfutils"].opt_include}
      -DLIBDWARF_LIBRARIES=#{Formula["dwarfutils"].opt_lib}/libdwarf.a
      -DLIBMAGICKWAND_INCLUDE_DIRS=#{Formula["imagemagick"].opt_include}/ImageMagick-6
      -DLIBMAGICKWAND_LIBRARIES=#{Formula["imagemagick"].opt_lib}/libMagickWand-6.Q16.dylib
      -DFREETYPE_INCLUDE_DIRS=#{Formula["freetype"].opt_include}/freetype2
      -DFREETYPE_LIBRARIES=#{Formula["freetype"].opt_lib}/libfreetype.dylib
      -DLIBMEMCACHED_INCLUDE_DIR=#{Formula["libmemcached"].opt_include}
      -DLIBMEMCACHED_LIBRARY=#{Formula["libmemcached"].opt_lib}/libmemcached.dylib
      -DLIBELF_INCLUDE_DIRS=#{Formula["libelf"].opt_include}/libelf
      -DLIBELF_LIBRARIES=#{Formula["libelf"].opt_lib}/libelf.a
      -DLIBGLOG_INCLUDE_DIR=#{Formula["glog"].opt_include}
      -DLIBGLOG_LIBRARY=#{Formula["glog"].opt_lib}/libglog.dylib
      -DOPENSSL_INCLUDE_DIR=#{Formula["openssl"].opt_include}
      -DOPENSSL_SSL_LIBRARY=#{Formula["openssl"].opt_lib}/libssl.dylib
      -DOPENSSL_CRYPTO_LIBRARY=#{Formula["openssl"].opt_lib}/libcrypto.dylib
      -DTBB_INSTALL_DIR=#{Formula["tbb"].opt_prefix}
      -DLIBSQLITE3_INCLUDE_DIR=#{Formula["sqlite"].opt_include}
      -DLIBSQLITE3_LIBRARY=#{Formula["sqlite"].opt_lib}/libsqlite3.dylib
    ]

    # Debug builds. This switch is all that's needed, it sets all the right
    # cflags and other config changes.
    cmake_args << "-DCMAKE_BUILD_TYPE=Debug" if build.with? "debug"

    system "cmake", *cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.php").write <<-EOS.undent
      <?php
      exit(is_integer(HHVM_VERSION_ID) ? 0 : 1);
    EOS
    system "#{bin}/hhvm", testpath/"test.php"
  end
end
