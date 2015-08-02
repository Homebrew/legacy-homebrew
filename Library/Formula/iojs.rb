class Iojs < Formula
  desc "npm-compatible platform based on Node.js"
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v2.5.0/iojs-v2.5.0.tar.xz"
  sha256 "0ad1bca083cbdf9a67fc55e1b1d47d8cc3bc6473e4a3af083c9f67ace3e7e75e"

  bottle do
    sha256 "9b1e8906ae4c9ed18c6764e79a1be9bc6ca90ef3947f82dbb2409c3953731fc7" => :yosemite
    sha256 "9a6ca219d8ef57375c58684a93ad436c5c189fbe129f8375421d3c6c32743138" => :mavericks
    sha256 "40115d9e139eb8a6b193ecbab9c2cf042b91381d4f6a4f6fbabde793691ae137" => :mountain_lion
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
