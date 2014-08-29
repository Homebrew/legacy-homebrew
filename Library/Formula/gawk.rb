require "formula"

class Gawk < Formula
  homepage "http://www.gnu.org/software/gawk/"
  url "http://ftpmirror.gnu.org/gawk/gawk-4.1.1.tar.xz"
  mirror "http://ftp.gnu.org/gnu/gawk/gawk-4.1.1.tar.xz"
  sha1 "547feb48d20e923aff58daccee97c94e047fdc18"

  bottle do
    sha1 "8fa017184dc02cdc122d5681b6824fd12be01def" => :mavericks
    sha1 "141a930482411bf368444dc214b87bd97a44360a" => :mountain_lion
    sha1 "a01d86d2749c9757c4e45e48154844f8fa5edce3" => :lion
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
