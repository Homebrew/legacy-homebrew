require 'formula'

class Msmtp < Formula
  homepage 'http://msmtp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/msmtp/msmtp/1.4.31/msmtp-1.4.31.tar.bz2'
  sha1 'c0edce1e1951968853f15209c8509699ff9e9ab5'

  depends_on 'pkg-config' => :build

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
