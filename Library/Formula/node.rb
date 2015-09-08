class Node < Formula
  desc "Platform built on Chrome's JavaScript runtime to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v4.0.0/node-v4.0.0.tar.gz"
  sha256 "e110e5a066f3a6fe565ede7dd66f3727384b9b5c5fbf46f8db723d726e2f5900"

  option "with-debug", "Build with debugger hooks"
  option "with-icu4c", "Build with Intl (icu4c) support"

  depends_on "pkg-config" => :build
  depends_on "icu4c" => :optional
  depends_on :python => :build if MacOS.version <= :snow_leopard

  def install
    args = %W[--prefix=#{prefix}]
    args << "--debug" if build.with? "debug"
    args << "--with-intl=system-icu" if build.with? "icu4c"

    system "./configure", *args
    system "make", "install"
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = `#{bin}/node #{path}`.strip
    assert_equal "hello", output
    assert_equal 0, $?.exitstatus
  end
end
