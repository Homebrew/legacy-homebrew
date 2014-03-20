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

      if build.with? 'python'
        # Per #25118, CMake does a poor job of detecting a brewed Python.
        # We need to tell CMake explicitly where our default python lives.
        # Inspired by
        # https://github.com/Homebrew/homebrew/blob/51d054c/Library/Formula/opencv.rb
        args << '--python' << '--'

        python_prefix = `python-config --prefix`.strip
        args << "-DPYTHON_LIBRARY='#{python_prefix}/Python'"
        args << "-DPYTHON_INCLUDE_DIR='#{python_prefix}/Headers'"
      end

      system "./acprep", "--prefix=#{prefix}", *args
      (share+'ledger').install 'python/demo.py', 'test/input/sample.dat', Dir['contrib']
    else
      args = []
      if build.with? 'libofx'
        args << "--enable-ofx"
        # the libofx.h appears to have moved to a subdirectory
        ENV.append 'CXXFLAGS', "-I#{Formula["libofx"].opt_include}/libofx"
      end
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}", *args
      system 'make'
      ENV.deparallelize
      system 'make install'
      (share+'ledger').install 'sample.dat', Dir['scripts']
    end
  end

  test do
    output = `#{bin}/ledger --file #{share}/ledger/sample.dat balance --collapse equity`
    assert_equal '          $-2,500.00  Equity', output.split(/\n/)[0]
    assert_equal 0, $?.exitstatus

    if build.head? and build.with? 'python'
      system "python", "#{share}/ledger/demo.py"
    end
  end
end
