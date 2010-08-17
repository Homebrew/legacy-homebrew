require 'formula'

class Nmap <Formula
  url 'http://nmap.org/dist/nmap-5.35DC1.tar.bz2'
  homepage 'http://nmap.org/5/'
  md5 '5bc2f8629f26716aa78d4bfe474a5d3a'
  version '5.35DC1'

  def install
    fails_with_llvm
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", "--without-zenmap"
    system "make" # seperate steps required otherwise the build fails
    system "make install"
  end
end
