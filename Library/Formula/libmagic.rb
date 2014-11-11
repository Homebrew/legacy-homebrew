require 'formula'

class Libmagic < Formula
  homepage 'http://www.darwinsys.com/file/'
  url 'ftp://ftp.astron.com/pub/file/file-5.20.tar.gz'
  mirror 'http://fossies.org/unix/misc/file-5.20.tar.gz'
  sha1 '4e93e9ae915f1812b05cc6012ae968fdb6416f8f'

  bottle do
    revision 1
    sha1 "6baadff8fb4c75b791843d89b9c4ea9d49372588" => :yosemite
    sha1 "c3b661f0a7f7bf2ce31e10676d1192f9393c48de" => :mavericks
    sha1 "eb205a948d8054253e23725a1046883eb7fc7f4c" => :mountain_lion
  end

  option :universal

  depends_on :python => :optional

  # Fixed upstream, should be in next release
  # See http://bugs.gw.com/view.php?id=230
  patch :DATA if MacOS.version < :lion

  # Fixed upstream, should be in next release.
  # See: http://bugs.gw.com/view.php?id=387
  #      http://bugs.gw.com/view.php?id=388
  patch :p1 do
    url 'https://gist.githubusercontent.com/kwilczynski/350e83c291b536ce9b5b/raw/1961a222d13cd3e010ecd7b0ebbc6909def27ad6/337-338.diff'
    sha1 'b220e2b0639cba97296e25c07c58a4d675104c8f'
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
