class Iojs < Formula
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v1.2.0/iojs-v1.2.0.tar.xz"
  sha256 "d33b448d173a0df675c471d24a33db57208c30b3e30b8c49f3b1d0666178e9cb"

  bottle do
    sha1 "f144662eb7b3a35a6bf02c991432a4c6d8f85fec" => :yosemite
    sha1 "223c47b26449e6fd3094fcb71ecfbb4aef466557" => :mavericks
    sha1 "0be6033eaa74eff52524efa6c0967bb1d5a78794" => :mountain_lion
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
