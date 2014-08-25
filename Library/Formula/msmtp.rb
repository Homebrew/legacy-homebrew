require "formula"

class Msmtp < Formula
  homepage "http://msmtp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/msmtp/msmtp/1.4.32/msmtp-1.4.32.tar.bz2"
  sha1 "03186a70035dbbf7a31272a20676b96936599704"
  revision 1

  bottle do
    sha1 "17021ef72dbf0c141e352531a2a61923c55a91b7" => :mavericks
    sha1 "ccc3ff12b2a2bd7299b3fc918eaafa3546a95598" => :mountain_lion
    sha1 "c028b723e3c4a888b05935a3b5a5e65889e53d7e" => :lion
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
