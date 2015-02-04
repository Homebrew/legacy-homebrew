class Iojs < Formula
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v1.1.0/iojs-v1.1.0.tar.xz"
  sha256 "2baa9b076c84c13b0572de4618ac94058fc98a87266925bcd18fb70fb7d521a7"

  bottle do
    sha1 "a88bf32209a487ed8329476325aeeed2cc5ddb33" => :yosemite
    sha1 "1bb64de12cdbfc2c5fc4aa662c1025ee2bed84b2" => :mavericks
    sha1 "f62a32113ae476095c7bcdee8dffe6c87f3675a8" => :mountain_lion
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

    if build.with? "icu4c"
      ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["icu4c"].opt_lib}/pkgconfig"
      args << "--with-intl=system-icu"
    end

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
