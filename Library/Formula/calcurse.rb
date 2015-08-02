class Calcurse < Formula
  desc "Text-based personal organizer"
  homepage "http://calcurse.org/"
  url "http://calcurse.org/files/calcurse-4.0.0.tar.gz"
  sha256 "621b0019907618bd468f9c4dc1ce2186ee86254d3c9ade47dd2d7ab8e6656334"

  depends_on "gettext"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"calcurse", "-v"
  end
end
