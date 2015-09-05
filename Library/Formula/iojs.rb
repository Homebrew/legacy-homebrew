class Iojs < Formula
  desc "npm-compatible platform based on Node.js"
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v3.2.0/iojs-v3.2.0.tar.xz"
  sha256 "52bf6b872ae97f4152acf8387657a23280e83ddee8f0d2ea620c5d36d067358c"

  bottle do
    sha256 "e4bc33b13a4b547b21f002055f9fc267ba8cd55b488bbb4129f81b2ce7144ad6" => :yosemite
    sha256 "148f64235bda9701088abb027dcc2c1a12b77b707f83d6302535a410abfc31ce" => :mavericks
    sha256 "434bab78bc9826f4e27d6939e79bd036f254625fcd5e5d9e36a985d86bfd5287" => :mountain_lion
  end

  keg_only "iojs conflicts with node (which is currently more established)"

  option "with-debug", "Build with debugger hooks"
  option "with-icu4c", "Build with Intl (icu4c) support"

  depends_on "pkg-config" => :build
  depends_on "icu4c" => :optional
  depends_on :python => :build if MacOS.version <= :snow_leopard

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
