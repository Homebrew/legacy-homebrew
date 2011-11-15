require 'formula'

class Nmap < Formula
  url 'http://nmap.org/dist/nmap-5.51.tar.bz2'
  homepage 'http://nmap.org/5/'
  md5 '0b80d2cb92ace5ebba8095a4c2850275'
  head 'https://guest:@svn.nmap.org/nmap/', :using => :svn

  # Leopard's version of OpenSSL isn't new enough
  depends_on "openssl" if MacOS.leopard?

  fails_with_llvm :build => 2334

  def install
    ENV.deparallelize

    args = ["--prefix=#{prefix}", "--without-zenmap"]

    if MacOS.leopard?
      openssl = Formula.factory('openssl')
      args << "--with-openssl=#{openssl.prefix}"
    end

    system "./configure", *args
    system "make" # separate steps required otherwise the build fails
    system "make install"
  end
end
