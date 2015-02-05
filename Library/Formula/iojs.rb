class Iojs < Formula
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v1.1.0/iojs-v1.1.0.tar.xz"
  sha256 "2baa9b076c84c13b0572de4618ac94058fc98a87266925bcd18fb70fb7d521a7"

  bottle do
    sha1 "c9788ec4ef2764db5b4f7c131d06517990802f8e" => :yosemite
    sha1 "d771ecaeac05d8edb17c494dae459f48bed5130f" => :mavericks
    sha1 "6c6cd07a5e7fb5c90146015984a8ae0e536fbefc" => :mountain_lion
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
