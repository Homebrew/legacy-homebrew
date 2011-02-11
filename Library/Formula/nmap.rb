require 'formula'

class Nmap <Formula
  url 'http://nmap.org/dist/nmap-5.50.tar.bz2'
  homepage 'http://nmap.org/5/'
  md5 'a4df96e52cb52a1bbe76caace5f21388'

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
