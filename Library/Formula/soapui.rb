require 'formula'

class Soapui < Formula
  homepage 'http://www.soapui.org/'
  url 'http://sourceforge.net/projects/soapui/files/soapui/4.5.1/soapui-4.5.1-mac-bin.zip'
  version '4.5.1'
  sha1 'b2386e22259d9b8746e0f57fe03a61af16461f6d'

  def patches
    # fixes SOAPUI_HOME
    DATA
  end

  def install
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*.sh"]
    system "chmod +x " "#{libexec}/bin/*.sh"      
  end

  def test
    system "#{bin}/soapui", "-e", "puts 'hello'"
  end
end

__END__
diff --git a/bin/soapui.sh b/bin/soapui.sh
index a77a3de..1f681b1 100644
--- a/bin/soapui.sh
+++ b/bin/soapui.sh
@@ -21,7 +21,7 @@ esac
 if [ "x$SOAPUI_HOME" = "x" ];
 then
     # get the full path (without any relative bits)
-    SOAPUI_HOME=`cd $DIRNAME/..; pwd`
+    SOAPUI_HOME=HOMEBREW_PREFIX/Cellar/soapui/4.5.1/libexec
 fi
 export SOAPUI_HOME