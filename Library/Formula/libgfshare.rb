class Libgfshare < Formula
  desc "Library for sharing secrets"
  homepage "https://www.digital-scurf.org/software/libgfshare"
  url "https://www.digital-scurf.org/files/libgfshare/libgfshare-2.0.0.tar.bz2"
  sha256 "86f602860133c828356b7cf7b8c319ba9b27adf70a624fe32275ba1ed268331f"

  bottle do
    cellar :any
    sha256 "6929a937f6f8ee624f02891622375d23aa65114475cf53ce82342976b4705454" => :yosemite
    sha256 "1696482fdd83b98b999d4b4037ae6c02d06a4b5297d089c826fed92a367d0d5c" => :mavericks
    sha256 "899c69bbb8b1b527d0f03da2c0118d96e90810ef659abe096d597bc11dcab3f8" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-linker-optimisations",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    touch "test.in"
    system "#{bin}/gfsplit", "test.in"
    system "#{bin}/gfcombine test.in.*"
  end
end
