class Iojs < Formula
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v1.6.3/iojs-v1.6.3.tar.xz"
  sha256 "79954738268ef0952a61549b951230fac70ce0f7fc709cae25b1d53039430380"

  bottle do
    sha256 "9a77790e7c4ebd5ec24a44d79edd6c1537501490b7deb7f5c12ef4b7aa8b22d3" => :yosemite
    sha256 "5d8364f59b1f6b274ff3ec0a96ee766609d1d840ab17ba854c5983d39b86dfb6" => :mavericks
    sha256 "52455c51e7c3b40f4b0cb2f178f76474ba3dd449c53176e7c5cf1b360f4af4cf" => :mountain_lion
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
