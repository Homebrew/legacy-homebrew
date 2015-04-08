class Iojs < Formula
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v1.6.4/iojs-v1.6.4.tar.xz"
  sha256 "bcbf57c1af6260980bed53f52d1d505eb09b8fa6f938ec70b415f363a96fdcdf"

  bottle do
    sha256 "7ba0151933b0e2a91296f5b0c9ae865a65d4b7ee729523427505c9095ef95449" => :yosemite
    sha256 "d1e66bb417275d8a2b96c184508017b62fda6b726275d466efc70870b992ca21" => :mavericks
    sha256 "b9fd2b1f888dfab437dfbd44dcc2ad8dc73b9d47e28ae79ba2f9c244949d3eab" => :mountain_lion
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
