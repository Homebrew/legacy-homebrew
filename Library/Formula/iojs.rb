class Iojs < Formula
  desc "npm-compatible platform based on Node.js"
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v2.2.1/iojs-v2.2.1.tar.xz"
  sha256 "26cce6e3581185ef3b1fe486a86ba9e18d611f6dfe439cfcbcfc8e639436a5bd"

  bottle do
    sha256 "c24990a50778929555e1b0032eb75884dbd446e3444b359abb1b77bdeb525a61" => :yosemite
    sha256 "6d2a124a4b806bd0eedd9e066bf44858f35b1164ea29b2761186851c712f31d3" => :mavericks
    sha256 "fe2a71d264d5aa6c942ccb02179cda693f364a79816e4d3f6dabedccfddeb02c" => :mountain_lion
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
