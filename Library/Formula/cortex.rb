require 'formula'

class Cortex < Formula
  head 'git://glacicle.org/projects/cortex.git'
  homepage 'http://cortex.glacicle.org'

  def patches
    DATA
  end

  def install
    bin.install "cortex"
  end
end
__END__
diff --git a/cortex b/cortex
index 8a41aad..6ee0f92 100755
--- a/cortex
+++ b/cortex
@@ -892,6 +892,7 @@ locale.setlocale(locale.LC_ALL,"")
 
 # {{{ Main function
 def main():
+    os.environ['TERM'] = 'xterm'
     if len(sys.argv) > 1 and sys.argv[1] in ("-v", "--version"):
         print(VERSIONTEXT)
     elif len(sys.argv) > 1 and sys.argv[1] in ("--help", "-h"):
