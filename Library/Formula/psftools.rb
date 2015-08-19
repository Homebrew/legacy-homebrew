class Psftools < Formula
  desc "Tools for fixed-width bitmap fonts"
  homepage "http://www.seasip.info/Unix/PSF/index.html"
  url "http://www.seasip.info/Unix/PSF/psftools-1.0.7.tar.gz"
  sha256 "d6f83e76efddaff86d69392656a5623b54e79cfe7aa74b75684ae3fef1093baf"

  depends_on "autoconf" => :build

  resource "pc8x8font" do
    url "http://www.zone38.net/font/pc8x8.zip"
    sha256 "13a17d57276e9ef5d9617b2d97aa0246cec9b2d4716e31b77d0708d54e5b978f"
  end

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    # The zip file has a fon in it, use fon2fnts to extrat to fnt
    resource("pc8x8font").stage do
      system "#{bin}/fon2fnts", "pc8x8.fon"
      assert File.exist?("PC8X8_9.fnt")
    end
  end
end
