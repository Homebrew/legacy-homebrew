class Iojs < Formula
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v1.8.1/iojs-v1.8.1.tar.xz"
  sha256 "8b9b4a141daca22e6bf28e8af86ce5f9ca5918d08923fb5619b7e614a674d966"

  bottle do
    sha256 "e535a806b9090b4ba229b4a724fd00a44f9df26f9614eb5cac6739376a9fd0b9" => :yosemite
    sha256 "e8a671371dfc9adaeea54b4410929ca4bafe9f62bc6b036f0f08f3c278409036" => :mavericks
    sha256 "023b19b7fa74a044a358157abdcab628c272860ecd9f12be5ac6aa3cce41da01" => :mountain_lion
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
