require 'formula'

class Nikto < Formula
  homepage 'http://cirt.net/nikto2'
  url 'https://cirt.net/nikto/nikto-2.1.4.tar.bz2'
  md5 '0d58d9ca27b9f387b60130e125db8687'

  def install
    etc.install Dir["nikto.conf"]
    mkdir "nikto"
    mv ["plugins", "templates"], "nikto"
    share.install Dir["nikto"]
    
    mv "nikto.pl", "nikto"
    bin.install Dir["nikto"]
  end
  
  def patches
    DATA
  end

end

__END__
diff --git a/nikto.conf b/nikto.conf
index 5859c34..e9e71e4 100644
--- a/nikto.conf
+++ b/nikto.conf
@@ -23,7 +23,7 @@ RFIURL=http://cirt.net/rfiinc.txt?
 #SKIPIDS=
 
 # if Nikto is having difficulty finding the 'plugins', set the full install path here
-# EXECDIR=/usr/local/nikto
+EXECDIR=/usr/local/share/nikto
 
 # The DTD
 NIKTODTD=docs/nikto.dtd
diff --git a/nikto.pl b/nikto.pl
index 0d1f6ee..68676cc 100755
--- a/nikto.pl
+++ b/nikto.pl
@@ -48,7 +48,7 @@ $COUNTERS{'scan_start'}  = time();
 $VARIABLES{'DIV'}        = "-" x 75;
 $VARIABLES{'name'}       = "Nikto";
 $VARIABLES{'version'}    = "2.1.4";
-$VARIABLES{'configfile'} = "/etc/nikto.conf";    ### Change if it's having trouble finding it
+$VARIABLES{'configfile'} = "/usr/local/etc/nikto.conf";    ### Change if it's having trouble finding it
 
 # signal trap so we can close down reports properly
 $SIG{'INT'} = \&safe_quit;
