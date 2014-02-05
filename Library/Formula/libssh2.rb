require 'formula'

class Libssh2 < Formula
  homepage 'http://www.libssh2.org/'
  url 'http://www.libssh2.org/download/libssh2-1.4.3.tar.gz'
  sha1 'c27ca83e1ffeeac03be98b6eef54448701e044b0'

  option 'with-brewed-openssl', 'Build with Homebrew OpenSSL instead of the system version'

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--with-libz",
      "--with-openssl"
    ]

    if MacOS.version <= :leopard or build.with?('brewed-openssl')
      args << "--with-libssl-prefix=#{Formula.factory('openssl').opt_prefix}"
    end

    system "./configure", *args
    system "make install"
  end
end
