require 'formula'

class Nmap <Formula
  url 'http://nmap.org/dist/nmap-5.51.tar.bz2'
  homepage 'http://nmap.org/5/'
  md5 '0b80d2cb92ace5ebba8095a4c2850275'

  # namp needs newer version of openssl on Leopard
  depends_on "openssl" if MACOS_VERSION < 10.6

  def install
    fails_with_llvm
    ENV.deparallelize

    args = ["--prefix=#{prefix}", "--without-zenmap"]

    if MACOS_VERSION < 10.6
      openssl = Formula.factory('openssl')
      args << "--with-openssl=#{openssl.prefix}"
    end

    system "./configure", *args
    system "make" # seperate steps required otherwise the build fails
    system "make install"
  end
end
