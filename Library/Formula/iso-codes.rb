require "formula"

class IsoCodes < Formula
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
