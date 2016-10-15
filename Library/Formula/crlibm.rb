require "formula"

class Crlibm < Formula
  homepage "http://lipforge.ens-lyon.fr/www/crlibm/"
  url "http://lipforge.ens-lyon.fr/frs/download.php/162/crlibm-1.0beta4.tar.gz"
  sha1 "7362162bcfceeda0ed885ce1bd8d4cd678f31d0f"
  version "1.0beta4"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
