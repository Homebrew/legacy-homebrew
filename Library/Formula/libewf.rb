require "formula"

class Libewf < Formula
  homepage "http://code.google.com/p/libewf/"
  url "https://googledrive.com/host/0B3fBvzttpiiSMTdoaVExWWNsRjg/libewf-20140608.tar.gz"
  sha1 "c17384a3d2c1d63bd5b1aaa2aead6ee3c82a2368"
  revision 1

  bottle do
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
