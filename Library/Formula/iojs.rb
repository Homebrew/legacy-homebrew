class Iojs < Formula
  desc "npm-compatible platform based on Node.js"
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v3.0.0/iojs-v3.0.0.tar.xz"
  sha256 "e003d162c923c4a4c3c2b122b59168dc7685c832c6fa876e969bfc2f406f9c16"

  bottle do
    sha256 "ee9137a3070298fa97f2a09a3ec2b90589fd2ba6f9821c95c9de25c6f1823f0a" => :yosemite
    sha256 "0936029971e177721eb89133e309eecd15a6ffa33418d84d1427e275b18ac196" => :mavericks
    sha256 "080cfc436e299b2ba2530ac929fd7ff75c6226f551ca46177a91944f407cab3d" => :mountain_lion
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
