require 'formula'

class Ncrack < Formula
  homepage 'http://nmap.org/ncrack/'
  url 'http://nmap.org/ncrack/dist/ncrack-0.4ALPHA.tar.gz'
  sha256 'f8bd7e0ef68559490064ec0a5f139b2b9c49aeaf9f6323e080db9ff344c87603'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
