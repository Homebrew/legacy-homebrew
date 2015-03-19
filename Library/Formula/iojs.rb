class Iojs < Formula
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v1.6.0/iojs-v1.6.0.tar.xz"
  sha256 "e7b1e3c5c709edb86264412e57d43814a9cb322ae392d7fb44e63265da5d1c7a"

  bottle do
    sha256 "37d7f88c3b8f07cd6ed9309a18db1804d5852ab5db1fcbb52ffac5cb68b5617f" => :yosemite
    sha256 "5cc7f526ef586e4f0d4cd6405ac8b250753d91f4ad4dbbd27a7d8e5c170cc79d" => :mavericks
    sha256 "185111fb5e69aae2185be541154fefdb897c2f2a05e03eae028ae8b4aebfdfc4" => :mountain_lion
  end

  keg_only "iojs conflicts with node (which is currently more established)"

  option "with-debug", "Build with debugger hooks"
  option "with-icu4c", "Build with Intl (icu4c) support"

  depends_on "pkg-config" => :build
  depends_on "icu4c" => :optional
  depends_on :python => :build

  def install
    args = %W[--prefix=#{prefix} --without-npm]
    args << "--debug" if build.with? "debug"
    args << "--with-intl=system-icu" if build.with? "icu4c"

    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    iojs was installed without npm.

    iojs currently requires a patched npm (i.e. not the npm installed by node).
    EOS
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = `#{bin}/iojs #{path}`.strip
    assert_equal "hello", output
    assert_equal 0, $?.exitstatus
  end
end
