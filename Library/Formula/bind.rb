require 'formula'

class Bind < Formula
  homepage 'http://www.isc.org/software/bind/'
  url 'ftp://ftp.isc.org/isc/bind9/9.8.1-P1/bind-9.8.1-P1.tar.gz'
  version '9.8.1-p1'
  sha256 '867fdd52d3436c6ab6d357108d7f9eaaf03f1422652e6e61c742816ff7f87929'

  depends_on "openssl" if MacOS.leopard?

  def install
      ENV['STD_CDEFINES']='-DDIG_SIGCHASE=1'
      system "./configure", "--prefix=#{prefix}",
                            "--enable-threads",
                            "--enable-ipv6",
                            "--with-openssl"
      system "make"
      system "make install"
  end
end
