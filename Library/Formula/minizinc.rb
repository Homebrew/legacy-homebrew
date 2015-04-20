require 'formula'

class Minizinc < Formula
  homepage 'http://www.minizinc.org'
  url 'http://www.minizinc.org/downloads/release-1.6/minizinc-1.6-x86_64-apple-darwin.tar.gz'
  sha1 '71f0e08962eb8bb44c463851f0144c8b006fdb80'

  depends_on :arch => :x86_64

  # remove echoed recommendations about linking directories
  # add installation location as parameter of SETUP script
  patch :DATA

  def install
    system "sh", "SETUP", libexec
    man.install Dir['doc/man/*']
    libexec.install 'bin', 'lib'
    bin.install_symlink Dir["#{libexec}/bin/*"]
    (bin/'private').unlink
  end

  test do
    system "#{bin}/mzn2fzn", "--help"
  end
end

__END__
diff --git a/SETUP b/SETUP
index 33d973e..7715800 100755
--- a/SETUP
+++ b/SETUP
@@ -33,7 +33,3 @@ chmod a+x bin/mzn2fzn
 #----------------------------------------------------------------------------#

 echo "-- G12 MiniZinc distribution setup complete."
-echo
-echo "-- Don't forget to add $INSTALL_PATH/bin to your PATH"
-echo "-- and $INSTALL_PATH/doc/man to your MANPATH."
-echo

diff --git a/SETUP b/SETUP
index 7715800..71c93b6 100755
--- a/SETUP
+++ b/SETUP
@@ -11,7 +11,7 @@
 
 #-----------------------------------------------------------------------------#

-INSTALL_PATH=`pwd`
+INSTALL_PATH=$1
 EXEEXT=""
  
 #----------------------------------------------------------------------------#
