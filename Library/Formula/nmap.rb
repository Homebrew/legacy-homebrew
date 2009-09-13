require 'brewkit'

class Nmap <Formula
  @url='http://nmap.org/dist/nmap-5.00.tar.bz2'
  @homepage='http://nmap.org/5/'
  @md5='32d27de32166c02d670bb4a086185886'

  def install
    system "./configure", "--prefix=#{prefix}", 
                          "--without-zenmap"
    
    system "make"                      
    system "make install" # seperate steps required otherwise the build fails
  end

  def caveats; <<-EOS
Root level scans do not work under Snow Leopard. 
More information: http://seclists.org/nmap-dev/2009/q3/0904.html

There is a fix but it was made after the 5.00 release, so if you need it 
install the latest Nmap from the subversion repository.
http://nmap.org/book/install.html#inst-svn
    EOS
  end
end
