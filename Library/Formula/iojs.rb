class Iojs < Formula
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v1.3.0/iojs-v1.3.0.tar.xz"
  sha256 "0c20c0d26d8c8e8814f02fd20fb5e57098f747692cddfd7453ffae973ebcebda"

  bottle do
    sha1 "336a6d77b2336896fbf3103c1fadae68201267d3" => :yosemite
    sha1 "1067f4f37195ca9096207581b98015828dbc477a" => :mavericks
    sha1 "cdcc1f499cc7ea2b17ebf0311a49a46352ba4ba4" => :mountain_lion
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
