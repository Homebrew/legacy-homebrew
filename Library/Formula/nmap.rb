require 'formula'

class Nmap <Formula
  url 'http://nmap.org/dist/nmap-5.50.tar.bz2'
  homepage 'http://nmap.org/5/'
  md5 'a4df96e52cb52a1bbe76caace5f21388'

  depends_on "openssl" if ARGV.include? "--brewed-openssl"

  def options
    [["--brewed-openssl", "Use OpenSSL installed via Homebrew (fixes compilation errors on Leopard)"]]
  end

  def install
    fails_with_llvm
    ENV.deparallelize

    args = ["--prefix=#{prefix}", "--without-zenmap"]
    args << "--with-openssl=" + Formula.factory('openssl').prefix.to_s if ARGV.include? "--brewed-openssl"

    system "./configure", *args
    system "make" # seperate steps required otherwise the build fails
    system "make install"
  end
end
