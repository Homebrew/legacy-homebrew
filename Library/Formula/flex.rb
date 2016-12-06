require 'formula'

class Flex <Formula
  url 'http://sourceforge.net/projects/flex/files/flex/flex-2.5.35/flex-2.5.35.tar.gz'
  homepage 'http://flex.sourceforge.net/'
  md5 '201d3f38758d95436cbc64903386de0b'


  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--infodir=#{prefix}/share/info", 
                          "--mandir=#{man}"
    
    system "make install"
    system "ln -sf flex HOMEBREW_PREFIX/bin/flex++"
    
  end
end
