require 'formula'

class Ledger < Formula
  homepage 'http://ledger-cli.org'
  url 'https://github.com/ledger/ledger/archive/v3.0.1.tar.gz'
  sha1 'cb0891f4770a33ba5cdbd6693b400ec0ff0b81da'
  head 'https://github.com/ledger/ledger.git', :branch => 'master'

  option 'debug', 'Build with debugging symbols enabled'

  depends_on 'gettext'
  depends_on 'utfcpp'
  depends_on 'boost'
  depends_on 'mpfr'
  depends_on 'gmp'
  depends_on :python => :optional
  depends_on 'cmake' => :build
  depends_on 'ninja' => :build

  def install
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
    (share+'ledger/examples').install Dir['test/input/*.dat']
    (share+'ledger').install Dir['contrib']
    if build.with? 'python'
      (share+'ledger').install 'python/demo.py'
    end
  end

  test do
    output = `#{bin}/ledger --file #{share}/ledger/examples/sample.dat balance --collapse equity`
    assert_equal '          $-2,500.00  Equity', output.split(/\n/)[0]
    assert_equal 0, $?.exitstatus

    if build.with? 'python'
      system "python", "#{share}/ledger/demo.py"
    end
  end
end
