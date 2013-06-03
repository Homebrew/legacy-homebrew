require 'formula'

class Ledger < Formula
  homepage 'http://ledger-cli.org'
  url 'https://github.com/downloads/ledger/ledger/ledger-2.6.3.tar.gz'
  sha1 '5b8e7d8199acb116f13720a5a469fff1f14b4041'

  head 'https://github.com/ledger/ledger.git', :branch => 'master'

  option 'debug', 'Build with debugging symbols enabled'

  depends_on 'boost'
  depends_on :python => :optional
  if build.head?
    depends_on 'cmake' => :build
    depends_on 'ninja' => :build
    depends_on 'mpfr'
    depends_on 'gmp'
  else
    depends_on 'gettext'
    depends_on 'pcre'
    depends_on 'expat'
    depends_on 'libofx' => :optional
  end

  def install
    opoo "Homebrew: Sorry, python bindings for --HEAD seem not to install. Help us fixing this!" if build.with? 'python'

    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    if build.head?
      args = [((build.include? 'debug') ? 'debug' : 'opt'), "make", "-N", "-j#{ENV.make_jobs}", "--output=build"]
      if build.with? 'python'
        args << '--python'
        # acprep picks up system python because CMake is used
        inreplace 'acprep', "self.configure_args  = []",
                            "self.configure_args  = ['-DPYTHON_INCLUDE_DIR=#{python.incdir}', '-DPYTHON_LIBRARY=#{python.libdir}/lib#{python.xy}.dylib']"
      end
      # Support homebrew not at /usr/local. Also support Xcode-only setups:
      inreplace 'acprep', 'search_prefixes = [', "search_prefixes = ['#{HOMEBREW_PREFIX}','#{MacOS.sdk_path}/usr',"
      system "./acprep", "--prefix=#{prefix}", *args
      system "cmake", "-P", "build/cmake_install.cmake", "-DUSE_PYTHON=ON"
    else
      args = []
      if build.with? 'libofx'
        args << "--enable-ofx"
        # the libofx.h appears to have moved to a subdirectory
        ENV.append 'CXXFLAGS', "-I#{Formula.factory('libofx').opt_prefix}/include/libofx"
      end
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}", *args
      system 'make'
      ENV.deparallelize
      system 'make install'
    end
  end
end
