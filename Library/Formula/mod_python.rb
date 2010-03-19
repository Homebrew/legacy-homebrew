require 'formula'

class ModPython <Formula
  url 'http://www.ibiblio.org/pub/mirrors/apache/httpd/modpython/mod_python-3.3.1.tgz'
  homepage 'http://www.modpython.org/'
  md5 'a3b0150176b726bd2833dac3a7837dc5'

  def caveats
    " * You must manually edit /etc/apache2/httpd.conf to load mod_python.so"
  end
  
  def patches
    { :p0 =>
      "http://trac.macports.org/export/38805/trunk/dports/www/mod_python25/files/patch-src-connobject.c.diff"
    }
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    
    inreplace 'Makefile' do |s|
      # Don't install to the system Apache libexec folder
      s.change_make_var! "LIBEXECDIR", libexec
    end

    system "make"
    system "make install"
  end
end
