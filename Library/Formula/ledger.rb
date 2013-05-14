require 'formula'

class Ledger < Formula
  homepage 'http://ledger-cli.org'
  url 'https://github.com/downloads/ledger/ledger/ledger-2.6.3.tar.gz'
  sha1 '5b8e7d8199acb116f13720a5a469fff1f14b4041'

  head 'https://github.com/ledger/ledger.git', :branch => 'master'

  option 'debug', 'Build with debugging symbols enabled'
  option 'python', 'Enable Python support'

  depends_on 'boost'
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
    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    if build.head?
      args = [((build.include? 'debug') ? 'debug' : 'opt'), "make", "-N", "-j#{ENV.make_jobs}", "--output=build"]
      args << '--python' if build.include? 'python'
      system "./acprep", *args
      system "cmake", "-D", "CMAKE_INSTALL_PREFIX=#{prefix}", "-P", "build/cmake_install.cmake"
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
