class Iojs < Formula
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v1.0.4/iojs-v1.0.4.tar.xz"
  version "1.0.4"
  sha1 "6247d3bb544353cf134e0857f4a60e7e04959bd4"

  keg_only "`iojs` symlinks conflict with `node` but can be used by prefixing your path"

  option "with-debug", "Build with debugger hooks"

  depends_on :python => :build


  def install
    args = %W[--prefix=#{prefix} --without-npm]
    args << "--debug" if build.with? "debug"

    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    `iojs` was installed without `npm`.

    To intall `npm` and have it use `iojs`, install `node` and add
    iojs to the front of your path:
      export PATH=#{HOMEBREW_PREFIX}/opt/iojs/bin:$PATH
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
