class Iat < Formula
  desc "Converts many CD-ROM image formats to ISO9660"
  homepage "http://iat.berlios.de/"
  url "https://downloads.sourceforge.net/project/iat.berlios/iat-0.1.7.tar.bz2"
  sha256 "fb72c42f4be18107ec1bff8448bd6fac2a3926a574d4950a4d5120f0012d62ca"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--includedir=#{include}/iat"
    system "make", "install"
  end
end
