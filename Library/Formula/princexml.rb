require 'formula'

class Princexml <Formula
  url 'http://www.princexml.com/download/prince-7.1-macosx.tar.gz'
  homepage 'http://www.princexml.com'
  md5 'dc239a14b7dbe4e9ff7cb05e7c9d29d2'
  version '7.1'

  def patches
    # Drop the user input since we're providing the prefix
    DATA
  end

  def install
    system "export prefix=#{prefix};install.sh"
  end
end
__END__
--- prince-7.1-macosx.orig/install.sh	2010-11-18 16:37:36.000000000 -0800
+++ prince-7.1-macosx/install.sh	2010-11-18 16:38:13.000000000 -0800
@@ -5,24 +5,10 @@
 VERSION="7.1"
 WEBSITE="http://www.princexml.com"
 
-prefix=/usr/local
-
 base=`dirname $0`
 
 cd "$base"
 
-echo "$PRODUCT $VERSION"
-echo
-echo "Install directory"
-echo "    This is the directory in which $PRODUCT $VERSION will be installed."
-echo "    Press Enter to accept the default directory or enter an alternative."
-echo -n "    [$prefix]: "
-
-read input
-if [ ! -z "$input" ] ; then
-    prefix="$input"
-fi
-
 echo
 echo "Installing $PRODUCT $VERSION..."
