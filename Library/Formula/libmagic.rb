require 'formula'

class Libmagic < Formula
  homepage 'http://www.darwinsys.com/file/'
  url 'ftp://ftp.astron.com/pub/file/file-5.19.tar.gz'
  mirror 'http://fossies.org/unix/misc/file-5.19.tar.gz'
  sha1 '0dff09eb44fde1998be79e8d312e9be4456d31ee'

  bottle do
    sha1 "35a401959b3925929ef220a35712a1a5f6f42ad9" => :mavericks
    sha1 "e4bdd610c71cb05bedfb00ce940ec476dbed4c29" => :mountain_lion
    sha1 "812930f1bb60fe40ec45e92bc385a8bd63e34813" => :lion
  end

  option :universal

  depends_on :python => :optional

  # Fixed upstream, should be in next release
  # See http://bugs.gw.com/view.php?id=230
  patch :DATA if MacOS.version < :lion

  def install
    ENV.universal_binary if build.universal?

    # Clean up "src/magic.h" as per http://bugs.gw.com/view.php?id=330
    rm "src/magic.h"

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
