require "formula"

class IipimageServer < Formula
  homepage "http://iipimage.sourceforge.net"
  url "https://github.com/ruven/iipsrv/archive/master.zip"
  version "0.9.9_git"
  sha1 "a83c6105dc9f6f594404b417d3ede17cc665e84e"

    # for git only
    depends_on "autogen"
    # for git only
    depends_on "autoconf"
    # for git only
    depends_on "automake"
    
    depends_on "mod_fastcgi"
    depends_on "fcgi"
    depends_on "lcms"
    depends_on "libgeotiff"
    depends_on "libmemcached"
    depends_on "libpng"
    
    
    

  def install
    system "./autogen.sh"
    system "./configure", 
      "--disable-dependency-tracking"
      
    system "make"
    mkdir_p "#{prefix}/Library/WebServer/CGI-Executables/"
    cp "src/iipsrv.fcgi", "#{prefix}/Library/WebServer/CGI-Executables/"
  end
    
    
  def caveats; <<-EOS.undent
    Note that this formula will install IIPImage Server in your system.
    In order to be able to use it you must create /etc/apache2/other/iipsrv.conf
    Here you can find an example:
    
      https://gist.githubusercontent.com/denics/b11d3995ab9fcb55bb53/raw/21f7463e08e600ed89471b7cff4f17e00db40605/iipsrv.conf

    Then, restart apache:
      
      sudo apachectl restart
      
    and open http://localhost/fcgi-bin/iipsrv.fcgi

EOS
  end

  test do
    system "#{prefix}/Library/WebServer/CGI-Executables/iipsrv.fcgi"
  end
end
