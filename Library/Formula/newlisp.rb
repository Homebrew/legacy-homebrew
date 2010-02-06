require 'formula'

class Newlisp <Formula
  url 'http://www.newlisp.org/downloads/newlisp-10.1.7.tgz'
  homepage 'http://www.newlisp.org/'
  md5 'e06313bf00226e51f7c70018e6d9e316'

  # This is basically a minimal install
  # as describe in the README
  def install
    system "./configure"
    system "make"
    system "cp newlisp #{prefix}/"
    
    bin.install 'newlisp'
    #FileUtils.ln_s prefix+'newlisp', prefix+'/bin/'
    #FileUtils.ln_s "#{prefix}/newlispdoc", "#{prefix}/bin/"
  end
    
  def caveats; <<-EOS
    Because of hardcoded paths in the newLISP source, 
    this formula does not install the Java-based IDE.
    EOS
  end
end
