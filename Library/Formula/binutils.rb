class Binutils < Formula
  desc "FSF Binutils for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "http://ftpmirror.gnu.org/binutils/binutils-2.25.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.25.1.tar.gz"
  sha256 "82a40a37b13a12facb36ac7e87846475a1d80f2e63467b1b8d63ec8b6a2b63fc"

  # No --default-names option as it interferes with Homebrew builds.

  bottle do
    sha256 "299f9bbdf522b68b803ce6cdb109a34b018459f3815771b3530ba95e06ee19f7" => :yosemite
    sha256 "30b13f1b4ddfe09f5140c2f00d0d34d42ed471ed2ab241405d8f5b7d3fb8eb41" => :mavericks
    sha256 "689d5c651fba64a18fed5f8f66ba9d156af7f3b8787e383afe8979f535432d64" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--program-prefix=g",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--disable-werror",
                          "--enable-interwork",
                          "--enable-multilib",
                          "--enable-64-bit-bfd",
                          "--enable-targets=all"
    system "make"
    system "make", "install"
  end

  test do
    assert_match /main/, shell_output("#{bin}/gnm #{bin}/gnm")
  end
end
