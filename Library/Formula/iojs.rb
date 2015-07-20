class Iojs < Formula
  desc "npm-compatible platform based on Node.js"
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v2.4.0/iojs-v2.4.0.tar.xz"
  sha256 "0081746e2e4b49c95ddbbaa6394960af2c719465c3ddab3bee58637b574eca45"

  bottle do
    sha256 "565454fceafca32280eeafd582eda82386fdbb85f173c0ed40dbdad920578915" => :yosemite
    sha256 "2856ffaeb27a8d365589d620a1ba4d591246d2a469fdf68ed42b0facd3f18ac9" => :mavericks
    sha256 "e285c52d618f8b2156afe16e657aecfe5f998af192bce5b5d706889a8edb2362" => :mountain_lion
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
