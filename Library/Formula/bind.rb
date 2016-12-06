require 'formula'

class Bind < Formula
  url 'ftp://ftp.isc.org/isc/bind9/9.8.1-P1/bind-9.8.1-P1.tar.gz'
  homepage 'http://www.isc.org/software/bind/'
  version '9.8.1-p1'
  sha256 '867fdd52d3436c6ab6d357108d7f9eaaf03f1422652e6e61c742816ff7f87929'

  depends_on "openssl" if MacOS.leopard?

  def install
      ENV['STD_CDEFINES']='-DDIG_SIGCHASE=1'
      args = [
          "--disable-debug",
          "--disable-dependency-tracking",
          "--prefix=#{prefix}",
          "--enable-threads",
          "--enable-ipv6",
          "--with-openssl"
      ]
      system "./configure", *args
      system "make"
      system "make install"
  end
end
