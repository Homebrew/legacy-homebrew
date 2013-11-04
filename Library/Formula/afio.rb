require 'formula'

class Afio < Formula
  homepage 'http://freecode.com/projects/afio/'
  url 'http://members.chello.nl/~k.holtman/afio-2.5.1.tgz'
  sha1 'bff6b9a147dc5b0e6bd7f1a76f0b84e4dd9a7dc9'

  option "bzip2", "Use bzip2(1) instead of gzip(1) for compression/decompression"

  def patches
    DATA
  end

  def install
    if build.include? "bzip2"
      inreplace "Makefile", "-DPRG_COMPRESS='\"gzip\"'", "-DPRG_COMPRESS='\"bzip2\"'"
      inreplace "afio.c", "with -o: gzip files", "with -o: bzip2 files"
      inreplace "afio.1", "gzip", "bzip2"
      inreplace "afio.1", "bzip2, bzip2,", "gzip, bzip2,"
    end

    system "make", "DESTDIR=#{prefix}", "install"

    prefix.install "ANNOUNCE-2.5.1" => "ANNOUNCE"
    %w(HISTORY INSTALLATION README SCRIPTS).each do |file|
      prefix.install file
    end

    man1.install 'afio.1'

    for n in 1..4 do
      share.install "script#{n}"
    end
  end
end

__END__
diff --git a/Makefile b/Makefile
index 5157453..bce4d3f 100644
--- a/Makefile
+++ b/Makefile
@@ -78,6 +78,8 @@ CC=gcc
 CFLAGS = ${CFLAGS1} $1 $2 $3 $4 $5 $6 $7 $8 $9 $a $b $c $d $e ${e2} $f $g $I
 LDFLAGS =
 
+DESTDIR += /usr/local
+
 afio : afio.o compfile.o exten.o match.o $M
 	${CC} ${LDFLAGS} afio.o compfile.o exten.o match.o $M -o afio
 
@@ -88,8 +90,8 @@ clean:
 	cd regtest; /bin/sh regtest.clean
 
 install: afio
-	cp afio /usr/local/bin
-	cp afio.1 /usr/share/man/man1
+	install -d ${DESTDIR}/bin
+	install -c -m 0755 afio ${DESTDIR}/bin
 
 # generate default list of -E extensions from manpage
 # note: on sun, I had to change awk command below to nawk or gawk

