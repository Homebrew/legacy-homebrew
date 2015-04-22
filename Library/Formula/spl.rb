class Spl < Formula
  homepage "http://www.clifford.at/spl/"
  url "http://www.clifford.at/spl/releases/spl-1.0pre6.tar.gz"
  sha256 "737658aea624f17ede8bb965b89cbd4acf40148906c55d3eebc8cc34d1755c30"
  version "1.0pre6"

  depends_on 'pcre' => :build
  depends_on 'postgres' => :build

  fails_with :clang do
    build 602
    cause <<-EOS.undent
        Requires nested functions, which are supported only by GCC.
    EOS
  end

  def install
    inreplace "GNUmakefile", 'prefix = /usr/local', "prefix = #{prefix}"
    system "make", "install"
  end

  test do
    system 'bash', '-c', <<-EOS.undent
        [ "$("#{bin}/splrun" -q 'write("Hello, world\\n");')" = "Hello, world" ]
    EOS
  end
end
