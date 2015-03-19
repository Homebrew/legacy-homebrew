class Iojs < Formula
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v1.6.0/iojs-v1.6.0.tar.xz"
  sha256 "e7b1e3c5c709edb86264412e57d43814a9cb322ae392d7fb44e63265da5d1c7a"

  bottle do
    sha256 "1fea2392d84a234520aa9b3cee506ef7a433bc0fdf1d4a5ec157d808191366c9" => :yosemite
    sha256 "e8c60ea9d64aff533b26d2029a7f57666fbb2b1837b5a49b280ef502b5f3e57d" => :mavericks
    sha256 "6f5b82b3687d93f8bea5b916574591c6bd05c767703b9b61ee07a007e155409d" => :mountain_lion
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
