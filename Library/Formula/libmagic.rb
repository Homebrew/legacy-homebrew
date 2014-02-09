require 'formula'

class Libmagic < Formula
  homepage 'http://www.darwinsys.com/file/'
  url 'ftp://ftp.astron.com/pub/file/file-5.16.tar.gz'
  mirror 'http://fossies.org/unix/misc/file-5.16.tar.gz'
  sha1 '12fd8ca35705bb24b00135ee65cb7de2d53aa69a'

  option :universal

  depends_on :python => :optional

  # Fixed upstream, should be in next release
  # See http://bugs.gw.com/view.php?id=230
  def patches
    p = []
    p << DATA if MacOS.version < :lion
  end

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-fsect-man5"
    system "make install"

    cd "python" do
      system "python", "setup.py", "install", "--prefix=#{prefix}"
    end

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
