require 'formula'

class Msmtp < Formula
  homepage 'http://msmtp.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/msmtp/msmtp/1.4.32/msmtp-1.4.32.tar.bz2'
  sha1 '03186a70035dbbf7a31272a20676b96936599704'

  depends_on 'pkg-config' => :build
  depends_on 'openssl'

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
