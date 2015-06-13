class Iojs < Formula
  desc "npm-compatible platform based on Node.js"
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v2.3.0/iojs-v2.3.0.tar.xz"
  sha256 "bca702877c2672151ee898992e8e88f07eb14c221bc261ed9613e1107e9b9a3e"

  bottle do
    sha256 "c61293b235d413ba047f2b9716bc54dfbb85cb7935086b45243ff27853e8cbed" => :yosemite
    sha256 "783ac8742ecf4cee3b5c74a24b101ab7f83b8047c629a2a4e613b5278c8300a1" => :mavericks
    sha256 "a1db572e2787edbc69df04176e1963d784ccdb4ae4ae791309d70b353b226b6f" => :mountain_lion
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
