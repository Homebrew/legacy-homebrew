require "formula"

class Msmtp < Formula
  homepage "http://msmtp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/msmtp/msmtp/1.4.32/msmtp-1.4.32.tar.bz2"
  sha1 "03186a70035dbbf7a31272a20676b96936599704"
  revision 1

  bottle do
    revision 2
    sha1 "339afdefd4f0979b3afeab1aaff0dca5de54c787" => :yosemite
    sha1 "382aa3a66edecf01844024f57ec9ffcb89e31988" => :mavericks
    sha1 "0ee0924a7f011b75f145e9b94b9af69fd1b37afd" => :mountain_lion
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
    (share/"msmtp/scripts").install "scripts/msmtpq"
  end
end
