require 'formula'

class Nmap <Formula
  url 'http://nmap.org/dist/nmap-5.50.tar.bz2'
  homepage 'http://nmap.org/5/'
  md5 'a4df96e52cb52a1bbe76caace5f21388'

  def install
    fails_with_llvm
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", "--without-zenmap"
    system "make" # seperate steps required otherwise the build fails
    system "make install"
  end
end
