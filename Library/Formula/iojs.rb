class Iojs < Formula
  desc "An npm-compatible platform based on Node.js"
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v2.2.1/iojs-v2.2.1.tar.xz"
  sha256 "26cce6e3581185ef3b1fe486a86ba9e18d611f6dfe439cfcbcfc8e639436a5bd"

  bottle do
    sha256 "99ae257901c2b7fa40e53ffe99eb4f047bc031f79eead84852a872e838204b5f" => :yosemite
    sha256 "05a2255b404bd1b723218200d3d56abbd1b9892c21e098490f6caeac2615a5ed" => :mavericks
    sha256 "45bd319865c8910ed6364681990b7d393193e7e219417877216970b3fbc0fcb7" => :mountain_lion
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
