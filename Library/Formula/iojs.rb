class Iojs < Formula
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v1.6.2/iojs-v1.6.2.tar.xz"
  sha256 "0015db12ebc7bdef4c44d88af08c964dea5fbf45a6e1218ed5ce26a275a4d3c6"

  bottle do
    sha256 "320bc71ce1b914a0f480c0e856d5a0a42b8bafb2caf139112a2ed46cfffa368b" => :yosemite
    sha256 "23541eaf4091912d9460f92ca9c077c0bb6aa18f3fb44d5e4066ff63a6d3bc04" => :mavericks
    sha256 "f379fea32ce86e9f47cd4d63fe2ef68a99f8996124f872ab89387d3b4cd6a8c7" => :mountain_lion
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
