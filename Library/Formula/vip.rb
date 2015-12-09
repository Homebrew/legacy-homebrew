class Vip < Formula
  desc "Program that provides for interactive editing in a pipeline"
  homepage "https://www.cs.duke.edu/~des/vip.html"
  url "https://www.cs.duke.edu/~des/scripts/vip"
  version "19971113"
  sha256 "171278e8bd43abdbd3a4c35addda27a0d3c74fc784dbe60e4783d317ac249d11"

  bottle do
    cellar :any_skip_relocation
    sha256 "1bf2041f43bcea1e8c503119a9b34f8849b751da767ec5b5094fd5fa8fe5f297" => :el_capitan
    sha256 "8e60ec9a240192f872f5d730ca93c9bc9e73d4644e685173554ff786b634ef7c" => :yosemite
    sha256 "96ae6a94171da559b1762970dc99b1c458ccd68c061d40248879d16bb6df8511" => :mavericks
  end

  resource "man" do
    url "https://www.cs.duke.edu/~des/scripts/vip.man"
    sha256 "37b2753f7c7b39c81f97b10ea3f8e2dd5ea92ea8d130144fa99ed54306565f6f"
  end

  # use awk and /var/tmp as temporary directory
  patch :DATA

  def install
    bin.install "vip"
    resource("man").stage do
      man1.install "vip.man" => "vip.1"
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
