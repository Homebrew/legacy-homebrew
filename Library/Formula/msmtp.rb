require "formula"

class Msmtp < Formula
  homepage "http://msmtp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/msmtp/msmtp/1.4.32/msmtp-1.4.32.tar.bz2"
  sha1 "03186a70035dbbf7a31272a20676b96936599704"
  revision 1

  bottle do
    revision 1
    sha1 "482d3583ebc0964f56c970e0310ed4ba639229e6" => :mavericks
    sha1 "d2c84e885cbf3e8910ade9c0c6715aac982dabe5" => :mountain_lion
    sha1 "0f45147dfade4a1a236839e787c33848c51a8143" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    args = %W[
      --disable-dependency-tracking
      --with-macosx-keyring
      --prefix=#{prefix}
      --with-ssl=openssl
    ]

    system "./configure", *args
    system "make", "install"
  end
end
