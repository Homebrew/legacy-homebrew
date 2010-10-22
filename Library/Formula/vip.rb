require 'formula'

class VipMan <Formula
  url 'http://www.cs.duke.edu/~des/scripts/vip.man'
  md5 'e94b80d7e594c68e13813e371250e521'
  version '19970805'
end

class Vip <Formula
  url 'http://www.cs.duke.edu/~des/scripts/vip'
  version '19971113'
  homepage 'http://www.cs.duke.edu/~des/vip.html'
  md5 '46b21408dcbaa4e58a862207bb70c42f'

  # use awk and /var/tmp as temporary directory
  def patches; DATA; end

  def install
    bin.install 'vip'
    VipMan.new.brew { man1.install 'vip.man' => 'vip.1' }
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
