class Iojs < Formula
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v2.0.2/iojs-v2.0.2.tar.xz"
  sha256 "afab3752cf9143a13784cd9d9c38b0ff5fd4aa77dffded2f5c3742c42b9743a2"

  bottle do
    sha256 "c2160a0165cb221045e3f5e2f2f634cd475de01272498a8ba14bb0cc3af3478c" => :yosemite
    sha256 "dd3d3a99cb3dcbb8c09b6c30bc7285721736ef8c6b9aa7637a4b3b853c703485" => :mavericks
    sha256 "906ce8e00fb54e445ba01d49485d42c4356c13a9db7a048a2756cabf3a810915" => :mountain_lion
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
