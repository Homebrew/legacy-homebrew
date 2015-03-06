class Iojs < Formula
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v1.4.3/iojs-v1.4.3.tar.xz"
  sha256 "ffcd739c59c7d4c1f4cbdbe288b9db2d8a7ea4605540701f28a32757bbe6dd28"

  bottle do
    sha1 "df191613915a1fcedc0042414762e5ad9ada4bdf" => :yosemite
    sha1 "45a0b2acfabba190a78fa93c5cadcbf84b23046c" => :mavericks
    sha1 "ff5b6183c768ceb6dedcc4b127c665f9c868a7e3" => :mountain_lion
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
