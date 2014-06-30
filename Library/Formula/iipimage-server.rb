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
    system "mkdir -p #{HOMEBREW_PREFIX}/Library/WebServer/CGI-Executables/"
    system "cp src/iipsrv.fcgi #{HOMEBREW_PREFIX}/Library/WebServer/CGI-Executables/"
  end
    
    
  def caveats; <<-EOS.undent
    Note that this formula will install IIPImage Server in your system.
    In order to be able to use it you must create a file called iipsrv.conf
    under "/etc/apache2/other/" with your preferred editor:
    
      sudo vi /etc/apache2/other/iipsrv.conf
      
    containing:
    
      LoadModule fastcgi_module /usr/local/Cellar/mod_fastcgi/2.4.6/libexec/mod_fastcgi.so
        
      # Create a directory for the iipsrv binary
      ScriptAlias /fcgi-bin/ "/usr/local/Library/WebServer/CGI-Executables/"
      # Set the module handler
      AddHandler fastcgi-script fcgi
      # Initialise some variables for the FCGI server
      FastCgiServer /usr/local/Library/WebServer/CGI-Executables/iipsrv.fcgi -initial-env LOGFILE=/tmp/iipsrv.log -initial-env VERBOSITY=5 -initial-env MAX_IMAGE_CACHE_SIZE=10 -initial-env JPEG_QUALITY=75 -initial-env MAX_CVT=3000

    Then, restart apache:
      
      sudo apachectl restart
      
    and open http://localhost/fcgi-bin/iipsrv.fcgi

EOS
  end

  test do
    system "#{HOMEBREW_PREFIX}/Library/WebServer/CGI-Executables/iipsrv.fcgi"
  end
end
