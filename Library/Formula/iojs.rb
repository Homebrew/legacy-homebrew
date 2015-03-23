class Iojs < Formula
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v1.6.2/iojs-v1.6.2.tar.xz"
  sha256 "0015db12ebc7bdef4c44d88af08c964dea5fbf45a6e1218ed5ce26a275a4d3c6"

  bottle do
    sha256 "84cf8a9eb38e7ffc49c2cb59eb7b5be254d264dd73b8ac1c549b4c9bcfbae286" => :yosemite
    sha256 "11f03e7c246e891b392e7c19b79616402823ef600859e92d894458732768aecd" => :mavericks
    sha256 "f57cfc8ebae21a8d0499d6181f55f5ccab06bfa14438f7e6dd2dde773d4dd28d" => :mountain_lion
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
