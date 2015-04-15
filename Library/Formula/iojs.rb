class Iojs < Formula
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v1.7.1/iojs-v1.7.1.tar.xz"
  sha256 "3c63010701b1968baf08d99327821c79746d0602ba71060c07d2bd9f1ff485f4"

  bottle do
    sha256 "9f771122f8b27072e7fc54afe33a7b67f5ad6571737da5f65702b08f2d9c8044" => :yosemite
    sha256 "8851413ea8b5090620f1e369796325293e6651b29e3f6f9a7e65e71c28033ead" => :mavericks
    sha256 "dbc81eb8f8519b5f41c45afc02c0b012c690a43065fd8205ee100a5e80813d73" => :mountain_lion
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
