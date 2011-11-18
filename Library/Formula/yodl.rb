require 'formula'

class Yodl < Formula
  url 'http://downloads.sourceforge.net/project/yodl/yodl/3.00.0/yodl_3.00.0.orig.tar.gz'
  head 'https://yodl.svn.sourceforge.net/svnroot/yodl/trunk/yodl', :using => :svn
  homepage 'http://yodl.sourceforge.net/'
  sha1 '909a34cf3e6d5429d8f8554fbace90d4d49ebc75'  
  version "3.0"
  
  depends_on 'icmake'
  
  def patches
    p = []
    # Fix sed usage
    p << "https://raw.github.com/gist/1377572/"
    return p
  end
  
  def install
    inreplace 'INSTALL.im', /void setLocations.*/m,
      <<-EOS.undent
      void setLocations() {
        BASE    = "#{prefix}";

        BIN     = "#{bin}";
        SKEL    = "#{share}";
        MAN     = "#{man}";    
        DOC     = "#{doc}";
        DOCDOC  = "#{doc.dirname() + "yodl-doc"}";
        
        COMPILER = "gcc";
      }
      EOS

    system "icmake build -- programs"
    system "icmake build -- man"
    # Use (badly) latex
    # system "icmake build -- manual"
    system "icmake build -- macros"

    # Usual way to install application (currently not working!)
    # system "icmake INSTALL -- programs /"
    # system "icmake install -- man /"
    # system "icmake install -- manual /"
    # system "icmake INSTALL -- macros /"
    # system "icmake install -- docs /"
     prefix.install Dir["tmp/install"+prefix+"/*"]
  end
end
