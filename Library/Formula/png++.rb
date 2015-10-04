class Pngxx < Formula
  desc "C++ wrapper for libpng library"
  homepage "http://www.nongnu.org/pngpp/"
  url "http://download.savannah.nongnu.org/releases/pngpp/png++-0.2.5.tar.gz"
  sha256 "339fa2dff2cdd117efb43768cb272745faef4d02705b5e0e840537a2c1467b72"
  revision 1

  depends_on "libpng"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end
end
