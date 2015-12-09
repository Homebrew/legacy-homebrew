class Ncrack < Formula
  desc "Network authentication cracking tool"
  homepage "https://nmap.org/ncrack/"
  url "https://nmap.org/ncrack/dist/ncrack-0.4ALPHA.tar.gz"
  sha256 "f8bd7e0ef68559490064ec0a5f139b2b9c49aeaf9f6323e080db9ff344c87603"
  revision 1

  bottle do
    revision 1
    sha256 "b3d1cf95c65ae4cf9cce81b7f1079ce87ad21fd740f09c4152893a0d904035dc" => :mavericks
    sha256 "4378178a1845aa3fa3edc2bb44321e72ca56e4c923cac4aebad63c8bc0883b38" => :mountain_lion
    sha256 "626bdefa3b73f3be9e88681b92e966b933fd21dc7a3d16da49588548340ebc5e" => :lion
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
