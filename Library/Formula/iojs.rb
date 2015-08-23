class Iojs < Formula
  desc "npm-compatible platform based on Node.js"
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v3.1.0/iojs-v3.1.0.tar.xz"
  sha256 "8d0e11833dd86517868ac95ea87732c0f9614bc3c10150abf1d133ce378dfe48"

  bottle do
    sha256 "c18ede09560539014d6ea794c01ba9f1e4fc057f06f4040a90c7d6b95283f7cd" => :yosemite
    sha256 "1805b8b51362715bcb20a14f45570bbe660a5da51b1c83bbb866391bef9741ae" => :mavericks
    sha256 "e3ad95292fe426fbf23faffed2e692fb841e0e17c70a2fc4d6d202b3b0d434c5" => :mountain_lion
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
