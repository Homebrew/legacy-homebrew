require 'formula'

class Cmus < Formula
  url 'http://downloads.sourceforge.net/cmus/cmus-v2.4.0.tar.bz2'
  homepage 'http://cmus.sourceforge.net/'
  md5 '0c5a9f4032e632e5f6b6a49f53df1e7e'

  depends_on 'pkg-config' => :build
  depends_on 'libao'
  depends_on 'mad'
  depends_on 'libogg'
  depends_on 'libvorbis'
  depends_on 'faad2'
  depends_on 'flac'
  depends_on 'mp4v2'

  skip_clean 'bin/cmus'
  skip_clean 'bin/cmus-remote'

  def patches
    # fix flac CFLAGS detection, already applied upstream:
    # https://gitorious.org/cmus/cmus/commit/51f7aaccab09f30ff6a683eec3163904c7148cb3
    DATA
  end

  def install
    system "./configure", "prefix=#{prefix}", "mandir=#{man}"
    system "make install"
  end
end
__END__
diff --git a/configure b/configure
index 127f64a..e8fbece 100755
--- a/configure
+++ b/configure
@@ -146,7 +146,12 @@ check_mpc()
 
 check_flac()
 {
-	pkg_config FLAC "flac" "" "-lFLAC -lm" && return 0
+	if pkg_config FLAC "flac" "" "-lFLAC -lm"
+	then
+		# Make sure the FLAC_CFLAGS value is sane, strip trailing '/FLAC'.
+		FLAC_CFLAGS=`echo $FLAC_CFLAGS | sed "s/FLAC$//"`
+		return 0
+	fi
 	check_library FLAC "" "-lFLAC -lvorbisfile -lm"
 	return $?
 }
