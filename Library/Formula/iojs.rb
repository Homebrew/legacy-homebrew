class Iojs < Formula
  desc "An npm-compatible platform based on Node.js"
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v2.2.0/iojs-v2.2.0.tar.xz"
  sha256 "197f1134cfa139dd6f8fcdce6e1a320996549bb936d45166372f43389b93081f"

  bottle do
    sha256 "9021459540d1a994e82caf3542c4d0a73683e21cab6ebda614563d25372fc334" => :yosemite
    sha256 "eccff554df6650ba6d0de7f1b57b7b7f2bf58c963963de5ef72299e54446c132" => :mavericks
    sha256 "a42b4035f20601357899db8c25f9dd450e0520162e447db702445447982653aa" => :mountain_lion
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
