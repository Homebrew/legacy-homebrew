require 'formula'

class Msmtp < Formula
  homepage 'http://msmtp.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/msmtp/msmtp/1.4.32/msmtp-1.4.32.tar.bz2'
  sha1 '03186a70035dbbf7a31272a20676b96936599704'

  depends_on 'pkg-config' => :build
  depends_on 'curl-ca-bundle' => :optional

  # msmtp enables OS X Keychain support by default, so no need to ask for it.

  def install
    # Msmtp will build against gnutls by default if it exists on the
    # system.  This sets up problems if the user later removes gnutls.
    # So explicitly ask for openssl, and ye shall receive it whether
    # or not gnutls is present.
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-ssl=openssl
    ]

    system "./configure", *args
    system "make", "install"
  end
end
