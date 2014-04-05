require 'formula'

class Libmagic < Formula
  homepage 'http://www.darwinsys.com/file/'
  url 'ftp://ftp.astron.com/pub/file/file-5.18.tar.gz'
  mirror 'http://fossies.org/unix/misc/file-5.18.tar.gz'
  sha1 '8753e72097f2cc935608e3b1c57c4c4e31bd8d21'

  bottle do
    sha1 "051692967234d6fd03b076aa6c2d1fe2a107d10d" => :mavericks
    sha1 "54e9744b6ac4d92f1845620f5d319ef643cc6c11" => :mountain_lion
    sha1 "6a099bb7975d54767b6209d04dcd4c276be9032a" => :lion
  end

  option :universal

  depends_on :python => :optional

  # Fixed upstream, should be in next release
  # See http://bugs.gw.com/view.php?id=230
  patch :DATA if MacOS.version < :lion

  # Fixed upstream, should be in next release.
  # See: http://bugs.gw.com/view.php?id=338
  #      http://bugs.gw.com/view.php?id=341
  #      http://bugs.gw.com/view.php?id=342
  patch :p1 do
    url 'https://gist.githubusercontent.com/kwilczynski/9925996/raw/483a877749c925a8dcc068de8e3ce5b92f5ea826/338-341-342.diff'
    sha1 'ff6f630bbe699091cb7d8228486f4de67b338fc8'
  end

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
