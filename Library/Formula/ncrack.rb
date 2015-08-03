class Ncrack < Formula
  desc "Network authentication cracking tool"
  homepage "http://nmap.org/ncrack/"
  url "http://nmap.org/ncrack/dist/ncrack-0.4ALPHA.tar.gz"
  sha256 "f8bd7e0ef68559490064ec0a5f139b2b9c49aeaf9f6323e080db9ff344c87603"
  revision 1

  bottle do
    revision 1
    sha1 "c3ab26f5b84bbb038c306b6d29abeef1f57614f7" => :mavericks
    sha1 "1f5e6e974cfcc4fbfd36783677a63f55d4e51aa8" => :mountain_lion
    sha1 "d385a3dfa6765075b5bad721cfe99f3eebd64c7f" => :lion
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
