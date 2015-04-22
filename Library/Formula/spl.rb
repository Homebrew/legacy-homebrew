# Note that SPL is unmaintained upstream; this formula is to make its last good state
# available on OS X for porting legacy projects.
class Spl < Formula
  homepage "http://www.clifford.at/spl/"
  url "http://www.clifford.at/spl/releases/spl-1.0pre6.tar.gz"
  sha256 "737658aea624f17ede8bb965b89cbd4acf40148906c55d3eebc8cc34d1755c30"
  version "1.0pre6" # This was the 6th prerelease candidate for 1.0, but no 1.0 is forthcoming

  depends_on "pcre" => :build
  depends_on "postgres" => :build

  fails_with :clang do
    build 602
    cause "Requires nested functions, which are supported only by GCC."
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "bash", "-c", <<-EOS.undent
        [ "$("#{bin}/splrun" -q 'write("Hello, world\\n");')" = "Hello, world" ]
    EOS
  end
end
