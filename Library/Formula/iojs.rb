class Iojs < Formula
  desc "npm-compatible platform based on Node.js"
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v2.3.4/iojs-v2.3.4.tar.xz"
  sha256 "cf8bdbcf8598a47c514ddd964dcbee40d6cd118f9954ee4afbec9163312e43a2"

  bottle do
    sha256 "e8e2402dde326d51eb436bf6d8d8ad793926650188240c44b5c97580fbe13758" => :yosemite
    sha256 "6075a3e1350679daa0c41cc8ad917ade5f98e82826d122ddc73637978d3ee573" => :mavericks
    sha256 "72a5677a0aa08df87538e1a4f2c61823c18169cc3dd8aef29d194f06b30b2b5d" => :mountain_lion
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
