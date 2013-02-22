require 'formula'

class Xmp < Formula
  homepage 'http://xmp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/xmp/xmp/4.0.1/xmp-4.0.1.tar.gz'
  sha1 'fc7f9e9575bb71817fbb47e8e9287a622ff59be0'

  depends_on 'libxmp'

  # 'uint8' doesn't exist on 10.6, just 'UInt8'
  # Patch submitted upstream: http://sourceforge.net/mailarchive/forum.php?thread_name=CAGLuM17HE3wUrYEVZ9HgEbpPcvcyGAeAR4uHNj7gjcCN%3DBN3Eg%40mail.gmail.com&forum_name=xmp-devel
  def patches; DATA; end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"

    # install the included demo song
    share.install "delicate_oooz!.mod"
  end

  def test
    system "#{bin}/xmp", "--load-only", "#{share}/delicate_oooz!.mod"
  end
end

__END__
diff --git a/src/sound_coreaudio.c b/src/sound_coreaudio.c
index 45a625b..33c3bec 100644
--- a/src/sound_coreaudio.c
+++ b/src/sound_coreaudio.c
@@ -21,7 +21,7 @@ static AudioUnit au;
  */
 
 static int paused;
-static uint8 *buffer;
+static UInt8 *buffer;
 static int buffer_len;
 static int buf_write_pos;
 static int buf_read_pos;
