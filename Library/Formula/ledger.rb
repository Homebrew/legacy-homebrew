require 'formula'

class Ledger < Formula
  homepage 'http://ledger-cli.org'
  url 'https://github.com/ledger/ledger/archive/v3.0.1.tar.gz'
  sha1 'cb0891f4770a33ba5cdbd6693b400ec0ff0b81da'
  head 'https://github.com/ledger/ledger.git', :branch => 'master'

  bottle do
    sha1 "700ac683623689a4086afaa64340609a8fdd53d1" => :mavericks
    sha1 "c9dd5c87767ed914f1631c4d3095d97a91a005a6" => :mountain_lion
    sha1 "4e0ec05ccbf893ea1e1d482253c972e0472267e4" => :lion
  end

  resource 'utfcpp' do
    url "http://downloads.sourceforge.net/project/utfcpp/utf8cpp_2x/Release%202.3.4/utf8_v2_3_4.zip"
    sha1 "638910adb69e4336f5a69c338abeeea88e9211ca"
  end

  option 'debug', 'Build with debugging symbols enabled'

  depends_on 'gettext'
  depends_on 'boost'
  depends_on 'mpfr'
  depends_on 'gmp'
  depends_on :python => :optional
  depends_on 'cmake' => :build
  depends_on 'ninja' => :build

  def install
    (buildpath/'lib/utfcpp').install resource('utfcpp')

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
    (share+'ledger').install 'contrib'
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
