require "formula"

class Gawk < Formula
  homepage "http://www.gnu.org/software/gawk/"
  url "http://ftpmirror.gnu.org/gawk/gawk-4.1.1.tar.xz"
  mirror "http://ftp.gnu.org/gnu/gawk/gawk-4.1.1.tar.xz"
  sha1 "547feb48d20e923aff58daccee97c94e047fdc18"

  bottle do
    revision 1
    sha1 "7efb956662b3283b96271179bd7c3fc1cc367197" => :yosemite
    sha1 "93f05ee77b9ae24aa7ae874b0e397439cd1b9192" => :mavericks
    sha1 "2205db37be8b453fd1d63d4bf8b19ce6bd2ee863" => :mountain_lion
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
