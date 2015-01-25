class Iojs < Formula
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v1.0.4/iojs-v1.0.4.tar.xz"
  sha256 "c902f5abbd59c56346680f0b4a71056c51610847b9576acf83a9c210bf664e98"

  bottle do
    sha1 "a88bf32209a487ed8329476325aeeed2cc5ddb33" => :yosemite
    sha1 "1bb64de12cdbfc2c5fc4aa662c1025ee2bed84b2" => :mavericks
    sha1 "f62a32113ae476095c7bcdee8dffe6c87f3675a8" => :mountain_lion
  end

  keg_only "`iojs` symlinks conflict with `node` but can be used by prepending your PATH"

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
      export PATH=#{Formula["iojs"].opt_bin}:$PATH
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
