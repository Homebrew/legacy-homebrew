require 'formula'

class Libmagic < Formula
  homepage 'http://www.darwinsys.com/file/'
  url 'ftp://ftp.astron.com/pub/file/file-5.13.tar.gz'
  mirror 'http://fossies.org/unix/misc/file-5.13.tar.gz'
  sha1 '927651df90ead6b3e036e243109137c7d42c4fb6'

  # Fixed upstream, should be in next release
  # See http://bugs.gw.com/view.php?id=230
  def patches; DATA; end if MacOS.version < :lion

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-fsect-man5"
    system "make install"

    # Don't dupe this system utility
    rm bin/"file"
    rm man1/"file.1"
  end
end

__END__
diff --git a/src/getline.c b/src/getline.c
index e3c41c4..74c314e 100644
--- a/src/getline.c
+++ b/src/getline.c
@@ -76,7 +76,7 @@ getdelim(char **buf, size_t *bufsiz, int delimiter, FILE *fp)
  }
 }
 
-ssize_t
+public ssize_t
 getline(char **buf, size_t *bufsiz, FILE *fp)
 {
  return getdelim(buf, bufsiz, '\n', fp);
