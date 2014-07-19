require "formula"

class Mdocml < Formula
  homepage "http://mdocml.bsd.lv/"
  url "http://mdocml.bsd.lv/snapshots/mdocml.140712.tar.gz"
  sha1 "79aa8fabdd559ed45a5609ed629cafa6ed5bc041"
  version "1.3.0-140712"

  patch :DATA

  def install
    ENV.append "CFLAGS", "-DUSE_MANPATH"
    system "make", "prefix=#{prefix}", "STATIC="
    bin.install "demandoc", "gmdiff", "makewhatis", "man.cgi", "mandoc", "manpage", "apropos" => "mandoc-apropos", "preconv" => "mandoc-preconv"
    man1.install "demandoc.1", "mandoc.1", "apropos.1" => "mandoc-apropos.1", "preconv.1" => "mandoc-preconv.1"
    man3.install "mandoc.3",  "mansearch.3",  "tbl.3"
    man5.install "mandoc.db.5"
    man7.install "eqn.7",  "man.7",  "mandoc_char.7",  "mdoc.7", "tbl.7", "roff.7" => "mandoc-roff.7"
    man8.install "makewhatis.8",  "man.cgi.8"
    (include/"mandoc").install "compat_ohash.h",  "config.h",  "html.h",  "libman.h",  "libmandoc.h",  "libmdoc.h",  "libroff.h",  "main.h",  "man.h",  "mandoc.h",  "mandoc_aux.h",  "manpath.h",  "mansearch.h",  "mdoc.h",  "out.h",  "term.h"
    lib.install "libmandoc.a"
    (share/"examples/mandoc").install "example.style.css", "man-cgi.css", "style.css"
  end

  test do
    system "#{bin}/mandoc", "-V"
  end
end

__END__
diff --git a/mansearch.h b/mansearch.h
index c78b00a..0e000b6 100644
--- a/mansearch.h
+++ b/mansearch.h
@@ -18,6 +18,8 @@
 #ifndef MANSEARCH_H
 #define MANSEARCH_H
 
+#include <stdint.h>
+
 #define	MANDOC_DB	 "mandoc.db"
 
 #define	TYPE_arch	 0x0000000000000001ULL
