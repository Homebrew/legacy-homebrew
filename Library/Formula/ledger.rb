require 'formula'

class Ledger < Formula
  homepage 'http://ledger-cli.org'

  stable do
    url 'https://github.com/downloads/ledger/ledger/ledger-2.6.3.tar.gz'
    sha1 '5b8e7d8199acb116f13720a5a469fff1f14b4041'

    depends_on 'gettext'
    depends_on 'pcre'
    depends_on 'expat'
    depends_on 'libofx' => :optional
  end

  head do
    url 'https://github.com/ledger/ledger.git', :branch => 'master'
    depends_on 'cmake' => :build
    depends_on 'ninja' => :build
    depends_on 'mpfr'
  end

  option 'debug', 'Build with debugging symbols enabled'

  depends_on 'boost'
  depends_on 'gmp'
  depends_on :python => :optional

  def install
    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    if build.head?
      # Support homebrew not at /usr/local. Also support Xcode-only setups:
      inreplace 'acprep', 'search_prefixes = [', "search_prefixes = ['#{HOMEBREW_PREFIX}','#{MacOS.sdk_path}/usr',"
      args = [((build.include? 'debug') ? 'debug' : 'opt'), "make", "install", "-N", "-j#{ENV.make_jobs}", "--output=build"]
      args << '--python' if build.with? 'python'
      system "./acprep", "--prefix=#{prefix}", *args
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

  def caveats; <<-EOS.undent
    If ledger was built with python support be sure to
    add #{HOMEBREW_PREFIX}/lib to your PYTHONPATH.
    EOS
  end
end
