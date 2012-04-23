require 'formula'

class Audiotools < Formula
  url 'http://sourceforge.net/project/audiotools/audiotools/2.18/audiotools-2.18.tar.gz'
  homepage 'http://audiotools.sourceforge.net/'
  md5 'b168a7e925941cadb1ee0506148db74d'

  depends_on 'libcdio'
  depends_on 'lame'
  depends_on 'two-lame'
  depends_on 'mp3gain'
  depends_on 'mpg123'
  depends_on 'faac'
  depends_on 'faad2'
  depends_on 'libogg'
  depends_on 'libvorbis'
  depends_on 'vorbisgain'
  depends_on 'vorbis-tools'

  def install
    system "make install"
  end

  def patches
    # fixes wrong paths and directs to /usr/local
    DATA
  end
end

__END__
diff --git a/docs/Makefile b/docs/Makefile
index 1c33b0b..e35a6ce 100644
--- a/docs/Makefile
+++ b/docs/Makefile
@@ -1,5 +1,5 @@
 PYTHON = python
-MAN_PATH = /usr/share/man
+MAN_PATH = /usr/local/share/man
 MAN_PAGES = \
 audiotools-config.1 \
 audiotools.cfg.5 \
diff --git a/setup.py b/setup.py
index dd5bd6f..5ab3d6d 100755
--- a/setup.py
+++ b/setup.py
@@ -115,7 +115,7 @@ setup(name='Python Audio Tools',
                    encodersmodule,
                    bitstreammodule,
                    verifymodule],
-      data_files=[("/etc", ["audiotools.cfg"])],
+      data_files=[("/usr/local/etc", ["audiotools.cfg"])],
       scripts=["cd2track", "cdinfo", "cdplay",
                "track2track", "trackrename", "trackinfo",
                "tracklength", "track2cd", "trackcmp", "trackplay",
