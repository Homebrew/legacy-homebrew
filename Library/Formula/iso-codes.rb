class IsoCodes < Formula
  desc "ISO language, territory, currency, script codes, and their translations"
  homepage "http://pkg-isocodes.alioth.debian.org/"
  url "http://pkg-isocodes.alioth.debian.org/downloads/iso-codes-3.58.tar.xz"
  sha256 "86af5735dce6e4eff2b983e5d8aa9a3dea1b8db702333ff20be89e45f7f35a72"

  depends_on "gettext" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
