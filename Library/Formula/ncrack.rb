require "formula"

class Ncrack < Formula
  homepage "http://nmap.org/ncrack/"
  url "http://nmap.org/ncrack/dist/ncrack-0.4ALPHA.tar.gz"
  sha256 "f8bd7e0ef68559490064ec0a5f139b2b9c49aeaf9f6323e080db9ff344c87603"
  revision 1

  bottle do
    sha1 "b2931a0cd792bde2eb8582f43bb43243e7542978" => :mavericks
    sha1 "9a743f6cef362833984f5eb9752b413f7f7960d8" => :mountain_lion
    sha1 "46c7cd34de5c0725fcee58cf90acfc7902b1335c" => :lion
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
