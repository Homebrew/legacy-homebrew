require 'formula'

class ContribFonts < Formula
  url 'ftp://ftp.figlet.org:21//pub/figlet/fonts/contributed.tar.gz'
  version "2.2.2"
  md5 '6e2dec4499f7a7fe178522e02e0b6cd1'
end

class InternationalFonts < Formula
  url 'ftp://ftp.figlet.org:21//pub/figlet/fonts/international.tar.gz'
  version "2.2.2"
  md5 'b2d53f7e251014adcdb4d407c47f90ef'
end

class Figlet < Formula
  url 'ftp://ftp.figlet.org/pub/figlet/program/unix/figlet-2.2.3.tar.gz'
  homepage 'http://www.figlet.org'
  md5 'c9e49dc83efc59070a00313b936002bf'

  def fonts
    share + "figlet/fonts"
  end

  def patches
    DATA
  end

  def install
    File.chmod 0666, 'Makefile'
    File.chmod 0666, 'showfigfonts'
    man6.mkpath
    bin.mkpath

    ContribFonts.new.brew { fonts.install Dir['*'] }
    InternationalFonts.new.brew { fonts.install Dir['*'] }

    inreplace "Makefile" do |s|
      s.gsub! "/usr/local/", "#{prefix}/"
      s.change_make_var! 'DEFAULTFONTDIR', fonts
      s.change_make_var! 'MANDIR', man6
    end

    system "make install"
  end
end

__END__
diff --git a/showfigfonts b/showfigfonts
index 643c60b..543379c 100644
--- a/showfigfonts
+++ b/showfigfonts
@@ -14,6 +14,7 @@
 DIRSAVE=`pwd`
 cd `dirname "$0"`
 PATH="$PATH":`pwd`
+FIGDIR=`pwd`
 cd "$DIRSAVE"
 
 # Get figlet version
@@ -42,12 +43,12 @@ else
     FONTDIR="`figlet -F | sed -e '1d' -e '3,$d' -e 's/Font directory: //'`"
   else
     # figlet 2.1 or later
-    FONTDIR="`figlet -I2`"
+    FONTDIR="`${FIGDIR}/figlet -I2`"
   fi
 fi
 
 cd "$FONTDIR"
-FONTLIST=`ls *.flf | sed s/\.flf$//`
+FONTLIST=`ls *.fl* | sed s/\.fl.$//`
 cd $DIRSAVE
 for F in $FONTLIST ; do
   echo "$F" :
