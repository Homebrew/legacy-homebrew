require 'formula'

class Nmap < Formula
  homepage 'http://nmap.org/6/'
  url 'http://nmap.org/dist/nmap-6.00.tar.bz2'
  md5 'e365cdada811c57e172b24b62746ab7d'

  head 'https://guest:@svn.nmap.org/nmap/', :using => :svn

  # Leopard's version of OpenSSL isn't new enough
  depends_on "openssl" if MacOS.leopard?

  fails_with :llvm do
    build 2334
  end

  def install
    ENV.deparallelize

    args = %W[--prefix=#{prefix}
              --with-libpcre=included
              --with-liblua=included
              --without-zenmap]

    if MacOS.leopard?
      openssl = Formula.factory('openssl')
      args << "--with-openssl=#{openssl.prefix}"
    end

    system "./configure", *args
    system "make" # separate steps required otherwise the build fails
    system "make install"
  end
end
