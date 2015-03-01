class Iojs < Formula
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v1.4.2/iojs-v1.4.2.tar.xz"
  sha256 "3a79cb83086fa76e6b231bdf4c288cfb4784b8eb2c07103d69c55bb39912e47a"

  bottle do
    sha1 "7f0b30b31ebcf4c3377abb435708db23ea38806b" => :yosemite
    sha1 "7ead98157a00771aa7f383bcc0aa08444bf5cc63" => :mavericks
    sha1 "26398c5bded85df1775a7e88a9333d0f1d3cfd02" => :mountain_lion
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
