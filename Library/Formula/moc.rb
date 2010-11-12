require 'formula'

class Moc <Formula
  url 'ftp://ftp.daper.net/pub/soft/moc/stable/moc-2.4.4.tar.bz2'
  homepage 'http://moc.daper.net'
  md5 '647c770a5542a4ae5437386807a89796'

  depends_on 'berkeley-db'
  depends_on 'jack'

  def patches
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
__END__
diff --git a/configure b/configure
index bd0e677..d61b55d 100755
--- a/configure
+++ b/configure
@@ -13929,7 +13929,7 @@ _ACEOF
 		;;
 esac

-LDFLAGS="$LDFLAGS -export-dynamic"
+LDFLAGS="$LDFLAGS -rdynamic"

 { echo "$as_me:$LINENO: checking for ANSI C header files" >&5
 echo $ECHO_N "checking for ANSI C header files... $ECHO_C" >&6; }
diff --git a/options.c b/options.c
index 2fa3d36..69cbc2b 100644
--- a/options.c
+++ b/options.c
@@ -172,8 +172,8 @@ void options_init ()
 	option_add_int ("SyncPlaylist", 1);
 	option_add_int ("InputBuffer", 512);
 	option_add_int ("Prebuffering", 64);
-	option_add_str ("JackOutLeft", "alsa_pcm:playback_1");
-	option_add_str ("JackOutRight", "alsa_pcm:playback_2");
+	option_add_str ("JackOutLeft", "system:playback_1");
+	option_add_str ("JackOutRight", "system:playback_2");
 	option_add_int ("ASCIILines", 0);
 	option_add_str ("FastDir1", NULL);
 	option_add_str ("FastDir2", NULL);
