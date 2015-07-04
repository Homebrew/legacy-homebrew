class Iojs < Formula
  desc "npm-compatible platform based on Node.js"
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v2.3.3/iojs-v2.3.3.tar.xz"
  sha256 "a9001633cc8baa282cea08e8712ef6b3df605d0c83ef3cbdae56ce0f3126488d"

  bottle do
    sha256 "6ef216280f457d4b0d25363efa2655c4e9cc67cc030f5932f0521d5e20941345" => :yosemite
    sha256 "d1b65c530fc7a6ce44ae690eec4e84417bda45f4e6dd2efd185c0274d385ab72" => :mavericks
    sha256 "0f4fc3181e18a19758fda23b8eefd4fe27092dac432218b43169578a9abd3e04" => :mountain_lion
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
