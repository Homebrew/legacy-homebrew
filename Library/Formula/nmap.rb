require 'formula'

class Nmap <Formula
  url 'http://nmap.org/dist/nmap-5.21.tar.bz2'
  homepage 'http://nmap.org/5/'
  md5 'f77fa51d89ab27d35e5cd87bb086b858'

  def install
    fails_with_llvm
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", "--without-zenmap"
    system "make"                      
    system "make install" # seperate steps required otherwise the build fails
  end
end
