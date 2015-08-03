class Libfreefare < Formula
  desc "API for MIFARE card manipulations"
  homepage "https://code.google.com/p/libfreefare/"
  url "https://libfreefare.googlecode.com/files/libfreefare-0.4.0.tar.bz2"
  sha256 "bfa31d14a99a1247f5ed49195d6373de512e3eb75bf1627658b40cf7f876bc64"
  revision 1

  bottle do
    cellar :any
    sha1 "5c480eebc127a8e05a6c2390a0b99823f631e92b" => :yosemite
    sha1 "2c4ab3dfc877588a4780605347e459d03ecfca6a" => :mavericks
    sha1 "3ef841880e81e9839b69ae5ede01e02ff922ac32" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libnfc"
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
