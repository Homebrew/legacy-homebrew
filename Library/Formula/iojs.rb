class Iojs < Formula
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v2.0.1/iojs-v2.0.1.tar.xz"
  sha256 "aa9f1d385e79689cb0c8311a607a726daafd6027428f1a33b2a16b2d08815290"

  bottle do
    sha256 "321a415f98a619cc540723322987e20c9afef404e5cb2dd46095b3f3b9d96cb2" => :yosemite
    sha256 "2c4ee52eab9da2912952306075a450bc49c9d92eecd77ff9650aed60dbf1cf9a" => :mavericks
    sha256 "b098bfea593735a43a34add4e8b0cf3ee663d6de72ad253fa2334c468b31aef6" => :mountain_lion
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
