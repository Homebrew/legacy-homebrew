class Liboauth < Formula
  desc "C library for the OAuth Core RFC 5849 standard"
  homepage "http://liboauth.sourceforge.net"
  url "https://downloads.sourceforge.net/project/liboauth/liboauth-1.0.3.tar.gz"
  sha256 "0df60157b052f0e774ade8a8bac59d6e8d4b464058cc55f9208d72e41156811f"
  revision 1

  bottle do
    cellar :any
    sha1 "82c2ad1ea5f0821f2f6e00d132c6b8ae57f49957" => :yosemite
    sha1 "d3afebefa5ffd84735eae7a65cb841ad1c212178" => :mavericks
    sha1 "4ace4ab98187d48ab61be90e0b3f2c5123db9dbc" => :mountain_lion
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-curl"
    system "make", "install"
  end
end
