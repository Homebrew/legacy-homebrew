class Iojs < Formula
  desc "npm-compatible platform based on Node.js"
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v3.3.1/iojs-v3.3.1.tar.xz"
  sha256 "c5b1a7117b75dca563f66c35ee65db6fc43e25a3756608ad2c4d60087314bd36"

  bottle do
    sha256 "11365cb0ea6f2317c7ebde018b43d34afd1be5d634ed4c3e63cd86beec733abb" => :el_capitan
    sha256 "9828d8b1b974f14a4b88c6b9f0eebb6d01d4f5fb1fe84496020e432447f67b7a" => :yosemite
    sha256 "1e59ce95f7d637ce63bab8da4a5bc8066917e20f9ba3200d658518ca23c85b8c" => :mavericks
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
