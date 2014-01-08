require 'formula'

class Nmap < Formula
  homepage 'http://nmap.org/'
  head 'https://guest:@svn.nmap.org/nmap/', :using => :svn
  url 'http://nmap.org/dist/nmap-6.40.tar.bz2'
  sha1 'ee1bec1bb62045c7c1fc69ff183b2ae9b97bd0eb'

  depends_on "openssl" if MacOS.version <= :leopard

  conflicts_with 'ndiff', :because => 'both install `ndiff` binaries'

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

    if MacOS.version <= :leopard
      openssl = Formula.factory('openssl')
      args << "--with-openssl=#{openssl.prefix}"
    end

    system "./configure", *args
    system "make" # separate steps required otherwise the build fails
    system "make install"
  end
end
