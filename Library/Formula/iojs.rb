class Iojs < Formula
  desc "npm-compatible platform based on Node.js"
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v2.4.0/iojs-v2.4.0.tar.xz"
  sha256 "0081746e2e4b49c95ddbbaa6394960af2c719465c3ddab3bee58637b574eca45"

  bottle do
    sha256 "ba290d26dd062790c0b37095eead0f2ab5dcfde0c3ea0637559524a6f379779a" => :yosemite
    sha256 "8269b4a75ed7ba9a882e1d83373fecac3eb2e77cb836016e715fe82b686a7f8d" => :mavericks
    sha256 "55f809bc4b62b30c240c6e1f3e09208b98b62f993ef75db5c3697cef7cba6303" => :mountain_lion
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
