class Mkvdts2ac3 < Formula
  desc "Convert DTS audio to AC3 within a matroska file"
  homepage "https://github.com/JakeWharton/mkvdts2ac3"
  revision 3
  head "https://github.com/JakeWharton/mkvdts2ac3.git"

  stable do
    url "https://github.com/JakeWharton/mkvdts2ac3/archive/1.6.0.tar.gz"
    sha256 "f9f070c00648c1ea062ac772b160c61d1b222ad2b7d30574145bf230e9288982"

    # patch with upstream fix for newer mkvtoolnix compatibility
    # https://github.com/JakeWharton/mkvdts2ac3/commit/f5008860e7ec2cbd950a0628c979f06387bf76d0
    patch :DATA
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d3eaf28d8c9718a73c2309eb8d9fc7c0a8db2ea6517324a80092ca02ac7842d4" => :el_capitan
    sha256 "4b4c9bf979e7ecd9efa254a9e5fdfe13a5549a209958f86e1233b8cc87a38e4b" => :yosemite
    sha256 "336cc7357b741d3e045a2c9a32f19f8daba41cfd3d00d2d3422d7b31c91ad538" => :mavericks
  end

  depends_on "mkvtoolnix"
  depends_on "ffmpeg"

  def install
    bin.install "mkvdts2ac3.sh" => "mkvdts2ac3"
  end
end

__END__
diff --git a/mkvdts2ac3.sh b/mkvdts2ac3.sh
index 270f768..156d60d 100755
--- a/mkvdts2ac3.sh
+++ b/mkvdts2ac3.sh
@@ -355,8 +355,18 @@ if [ $EXECUTE = 1 ]; then
 	checkdep perl
 fi
 
+# Make some adjustments based on the version of mkvtoolnix
+MKVTOOLNIXVERSION=$(mkvmerge -V | cut -d " " -f 2 | sed s/\[\^0-9\]//g)
+if [ ${MKVTOOLNIXVERSION} -lt 670 ]; then
+	AUDIOTRACKPREFIX="audio (A_"
+	VIDEOTRACKPREFIX="video (V_"
+else
+	AUDIOTRACKPREFIX="audio ("
+	VIDEOTRACKPREFIX="video ("
+fi
+
 # Added check to see if AC3 track exists.  If so, no need to continue
-if [ "$(mkvmerge -i "$MKVFILE" | grep -i "A_AC3")" ]; then
+if [ "$(mkvmerge -i "$MKVFILE" | grep -i "${AUDIOTRACKPREFIX}AC3")" ]; then
 	echo $"AC3 track already exists in '$MKVFILE'."
 	if [ $FORCE = 0 ]; then
 		echo $"Use -f or --force argument to bypass this check."
@@ -389,11 +399,11 @@ doprint $"WORKING DIRECTORY: $WD"
 if [ -z $DTSTRACK ]; then
 	doprint ""
 	doprint $"Find first DTS track in MKV file."
-	doprint "> mkvmerge -i \"$MKVFILE\" | grep -m 1 \"audio (A_DTS)\" | cut -d ":" -f 1 | cut -d \" \" -f 3"
+	doprint "> mkvmerge -i \"$MKVFILE\" | grep -m 1 \"${AUDIOTRACKPREFIX}DTS)\" | cut -d ":" -f 1 | cut -d \" \" -f 3"
 	DTSTRACK="DTSTRACK" #Value for debugging
 	dopause
 	if [ $EXECUTE = 1 ]; then
-		DTSTRACK=$(mkvmerge -i "$MKVFILE" | grep -m 1 "audio (A_DTS)" | cut -d ":" -f 1 | cut -d " " -f 3)
+		DTSTRACK=$(mkvmerge -i "$MKVFILE" | grep -m 1 "${AUDIOTRACKPREFIX}DTS)" | cut -d ":" -f 1 | cut -d " " -f 3)
 
 		# Check to make sure there is a DTS track in the MVK
 		if [ -z $DTSTRACK ]; then
@@ -405,10 +415,10 @@ if [ -z $DTSTRACK ]; then
 else
 	# Checks to make sure the command line argument track id is valid
 	doprint $"Checking to see if DTS track specified via arguments is valid."
-	doprint "> mkvmerge -i \"$MKVFILE\" | grep \"Track ID $DTSTRACK: audio (A_DTS)\""
+	doprint "> mkvmerge -i \"$MKVFILE\" | grep \"Track ID $DTSTRACK: ${AUDIOTRACKPREFIX}DTS)\""
 	dopause
 	if [ $EXECUTE = 1 ]; then
-		VALID=$(mkvmerge -i "$MKVFILE" | grep "Track ID $DTSTRACK: audio (A_DTS)")
+		VALID=$(mkvmerge -i "$MKVFILE" | grep "Track ID $DTSTRACK: ${AUDIOTRACKPREFIX}DTS)")
 
 		if [ -z "$VALID" ]; then
 			error $"Track ID '$DTSTRACK' is not a DTS track and/or does not exist."
@@ -555,14 +565,14 @@ else
 	# If user doesn't want the original DTS track drop it
 	if [ $NODTS ]; then
 		# Count the number of audio tracks in the file
-		AUDIOTRACKS=$(mkvmerge -i "$MKVFILE" | grep "audio (A_" | wc -l)
+		AUDIOTRACKS=$(mkvmerge -i "$MKVFILE" | grep "$AUDIOTRACKPREFIX" | wc -l)
 
 		if [ $AUDIOTRACKS -eq 1 ]; then
 			# If there is only the DTS audio track then drop all audio tracks
 			CMD="$CMD -A"
 		else
 			# Get a list of all the other audio tracks
-			SAVETRACKS=$(mkvmerge -i "$MKVFILE" | grep "audio (A_" | cut -d ":" -f 1 | grep -vx "Track ID $DTSTRACK" | cut -d " " -f 3 | awk '{ if (T == "") T=$1; else T=T","$1 } END { print T }')
+			SAVETRACKS=$(mkvmerge -i "$MKVFILE" | grep "$AUDIOTRACKPREFIX" | cut -d ":" -f 1 | grep -vx "Track ID $DTSTRACK" | cut -d " " -f 3 | awk '{ if (T == "") T=$1; else T=T","$1 } END { print T }')
 			# And copy only those
 			CMD="$CMD -a \"$SAVETRACKS\""
 
@@ -576,7 +586,7 @@ else
 	fi
 
 	# Get track ID of video track
-	VIDEOTRACK=$(mkvmerge -i "$MKVFILE" | grep -m 1 "video (V_" | cut -d ":" -f 1 | cut -d " " -f 3)
+	VIDEOTRACK=$(mkvmerge -i "$MKVFILE" | grep -m 1 "$VIDEOTRACKPREFIX" | cut -d ":" -f 1 | cut -d " " -f 3)
 	# Add original MKV file, set header compression scheme
 	CMD="$CMD --compression $VIDEOTRACK:$COMP \"$MKVFILE\""
 
