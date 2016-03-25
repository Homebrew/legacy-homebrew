class Binutils < Formula
  desc "FSF Binutils for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "http://ftpmirror.gnu.org/binutils/binutils-2.26.tar.gz"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.26.tar.gz"
  sha256 "9615feddaeedc214d1a1ecd77b6697449c952eab69d79ab2125ea050e944bcc1"

  bottle do
    sha256 "ab393fd01e8bb2f9ff697efa3e14765eb32468a46380ce8c2db0d5baf1b588b5" => :el_capitan
    sha256 "299f9bbdf522b68b803ce6cdb109a34b018459f3815771b3530ba95e06ee19f7" => :yosemite
    sha256 "30b13f1b4ddfe09f5140c2f00d0d34d42ed471ed2ab241405d8f5b7d3fb8eb41" => :mavericks
    sha256 "689d5c651fba64a18fed5f8f66ba9d156af7f3b8787e383afe8979f535432d64" => :mountain_lion
  end

  # No --default-names option as it interferes with Homebrew builds.

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
    assert_match "main", shell_output("#{bin}/gnm #{bin}/gnm")
  end
end
