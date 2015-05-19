require "formula"

class IsoCodes < Formula
  desc "ISO language, territory, currency, script codes, and their translations"
  homepage "http://pkg-isocodes.alioth.debian.org/"
  url "http://pkg-isocodes.alioth.debian.org/downloads/iso-codes-3.54.tar.xz"
  sha1 "8b07323ca36f976433e516709d86f67516628e3b"

  depends_on "gettext" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
