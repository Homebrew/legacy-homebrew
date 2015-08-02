class Mpop < Formula
  desc "POP3 client"
  homepage "http://mpop.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mpop/mpop/1.2.0/mpop-1.2.0.tar.xz"
  sha1 "efc02ff1761501f93d5ec55d40149fe362d29282"

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
