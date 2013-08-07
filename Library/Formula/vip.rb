require 'formula'

class Vip < Formula
  homepage 'http://www.cs.duke.edu/~des/vip.html'
  url 'http://www.cs.duke.edu/~des/scripts/vip'
  version '19971113'
  sha1 '0b2794b5ac2792af5fcf1d97f9aae04798eac049'

  resource 'man' do
    url 'http://www.cs.duke.edu/~des/scripts/vip.man'
    sha1 'd52ce874d594ca2c82538200706bffdf1313fdc1'
  end

  # use awk and /var/tmp as temporary directory
  def patches; DATA; end

  def install
    bin.install 'vip'
    resource('man').stage do
      man1.install 'vip.man' => 'vip.1'
    end
  end
end


__END__
diff --git a/vip b/vip
index f150167..e517675 100644
--- a/vip
+++ b/vip
@@ -66,7 +66,7 @@ Usage:  $PROG [ -no ] [ command ]
 			otherwise stdin is used;
 "
 
-: ${TMPDIR:="/usr/tmp"}		# where temp. files go
+: ${TMPDIR:="/var/tmp"}		# where temp. files go
 TEMP_FILE="$TMPDIR/$PROG.$$"	# temp. file to hold data to edit
 COMMAND="cat"			# default command to produce input
 DFLT_ED="vi"			# default editor
@@ -81,6 +81,10 @@ case "$SYS" in
 	;;
   "HP-UX "*)
 	AWK=awk
+	;;
+  "Darwin "*)
+	AWK=awk
+	;;
   esac
 
 #
