require 'formula'

class Ledger < Formula
  homepage 'http://ledger-cli.org'
  url 'https://github.com/ledger/ledger/archive/v3.0.3.tar.gz'
  sha1 'b65c2dc78f366fc3c2db9e2b7900b727b91f4656'
  head 'https://github.com/ledger/ledger.git', :branch => 'master'

  bottle do
    sha1 "700ac683623689a4086afaa64340609a8fdd53d1" => :mavericks
    sha1 "c9dd5c87767ed914f1631c4d3095d97a91a005a6" => :mountain_lion
    sha1 "4e0ec05ccbf893ea1e1d482253c972e0472267e4" => :lion
  end

  stable do
    resource 'utfcpp' do
      url "http://downloads.sourceforge.net/project/utfcpp/utf8cpp_2x/Release%202.3.4/utf8_v2_3_4.zip"
      sha1 "638910adb69e4336f5a69c338abeeea88e9211ca"
    end
  end

  option 'debug', 'Build with debugging symbols enabled'

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "mpfr"
  depends_on "gmp"
  depends_on :python => :optional

  boost_opts = []
  boost_opts << "with-python" if build.with? "python"
  boost_opts << "c++11" if MacOS.version < "10.9"
  depends_on "boost" => boost_opts

  needs :cxx11

  def install
    ENV.cxx11

    unless build.head?
      (buildpath/'lib/utfcpp').install resource('utfcpp')
    end

    flavor = build.include?("debug") ? "debug" : "opt"

    args = %W[
      --prefix=#{prefix}
      #{flavor} make install -N -j#{ENV.make_jobs}
      --output=build
      --boost=#{Formula["boost"].opt_prefix}
    ]

    if build.with? 'python'
      # Per #25118, CMake does a poor job of detecting a brewed Python.
      # We need to tell CMake explicitly where our default python lives.
      # Inspired by
      # https://github.com/Homebrew/homebrew/blob/51d054c/Library/Formula/opencv.rb
      args << "--python" << "--"
      python_prefix = `python-config --prefix`.strip
      args << "-DPYTHON_LIBRARY=#{python_prefix}/Python"
      args << "-DPYTHON_INCLUDE_DIR=#{python_prefix}/Headers"
    end

    system "./acprep", *args
    (share+'ledger/examples').install Dir['test/input/*.dat']
    (share+'ledger').install 'contrib'
    (share+"ledger").install "python/demo.py" if build.with? "python"
  end

  test do
    balance = testpath/'output'
    system bin/'ledger',
      '--args-only',
      '--file', share/'ledger/examples/sample.dat',
      '--output', balance,
      'balance', '--collapse', 'equity'
    assert_equal '          $-2,500.00  Equity', balance.read.chomp
    assert_equal 0, $?.exitstatus

    if build.with? 'python'
      system "python", "#{share}/ledger/demo.py"
    end
  end
end
