require 'formula'

class Nmap < Formula
  homepage 'http://nmap.org/6/'
  url 'http://nmap.org/dist/nmap-6.25.tar.bz2'
  sha1 '769943a1a5c10f67bf9738e26da42b3312db752f'

  head 'https://guest:@svn.nmap.org/nmap/', :using => :svn

  # Leopard's version of OpenSSL isn't new enough
  depends_on "openssl" if MacOS.version == :leopard

  fails_with :llvm do
    build 2334
  end

  def install
    ENV.deparallelize

    args = %W[--prefix=#{prefix}
              --with-libpcre=included
              --with-liblua=included
              --without-zenmap
              --disable-universal]

    if MacOS.version == :leopard
      openssl = Formula.factory('openssl')
      args << "--with-openssl=#{openssl.prefix}"
    end

    system "./configure", *args
    system "make" # separate steps required otherwise the build fails
    system "make install"
  end
end
