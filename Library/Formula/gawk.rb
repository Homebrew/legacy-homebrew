require "formula"

class Gawk < Formula
  homepage "https://www.gnu.org/software/gawk/"
  url "http://ftpmirror.gnu.org/gawk/gawk-4.1.2.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gawk/gawk-4.1.2.tar.xz"
  sha256 "ea8b53c5834ee27012fecba7273f97fca7104884975cf81ddae6f85c5581f481"

  bottle do
    sha256 "3870e56454e734670d30e89e45fcb756d14090ca3dc1f831b3ada52c2e10e0d4" => :yosemite
    sha256 "b4e858452e199ba6993d2d7f4958ab84a58f3775e630cd4f204b5ec56eeda66a" => :mavericks
    sha256 "61c42778345ee6497511380faa0537eb015d9e9b4625b7c199f8f1e51cca1039" => :mountain_lion
  end

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-readline",
                          "--without-mpfr",
                          "--without-libsigsegv-prefix"
    system "make"
    system "make check"
    system "make install"
  end

  test do
    output = pipe_output("#{bin}/gawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal 'Homebrew', output.strip
  end
end
