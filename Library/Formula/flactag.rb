require 'formula'

class Flactag < Formula
  homepage 'http://flactag.sourceforge.net/'
  url 'http://sourceforge.net/projects/flactag/files/v2.0.4/flactag-2.0.4.tar.gz'
  sha1 'eb62b3b8657fe26c6f838b0098fd4f176ccb454d'

  depends_on 'pkg-config' => :build
  depends_on 'asciidoc' => :build
  depends_on 'flac'
  depends_on 'libmusicbrainz'
  depends_on 'neon'
  depends_on 'libdiscid'
  depends_on 's-lang'
  depends_on 'unac'

  def patches
    # Don't have a2x run xmllint on the a2x-generated DocBook - it
    # fails its own validation.
    DATA
  end

  def install
    ENV.append 'LDFLAGS', '-liconv'
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/flactag"
  end
end

__END__
--- flactag-2.0.4/Makefile.in.orig	2013-02-26 22:57:46.000000000 -0800
+++ flactag-2.0.4/Makefile.in	2013-02-26 22:57:57.000000000 -0800
@@ -1137,7 +1137,7 @@
        chmod +x ripflac

 flactag.1:	flactag.1.txt Makefile
-	a2x -f manpage flactag.1.txt
+	a2x -L -f manpage flactag.1.txt

 flactag.html:	flactag.txt Makefile
        asciidoc -a numbered flactag.txt
