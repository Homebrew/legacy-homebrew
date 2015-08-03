class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "http://ftpmirror.gnu.org/gawk/gawk-4.1.3.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gawk/gawk-4.1.3.tar.xz"
  sha256 "e3cf55e91e31ea2845f8338bedd91e40671fc30e4d82ea147d220e687abda625"

  bottle do
    sha256 "c6fd269bedf83b9016fb8e09186de1c88ce18f51b1ad471f4b5ad4262066dda2" => :yosemite
    sha256 "30486a1665295a3fee02e22465869cec9297aec262554a470bbc7f127d1766e5" => :mavericks
    sha256 "d9edeb691699655ff990e2227abf67568916640eeffbbca959dbf3b2779c371e" => :mountain_lion
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
    system "make", "check"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/gawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
