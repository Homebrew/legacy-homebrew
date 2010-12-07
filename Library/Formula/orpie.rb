require 'formula'

class Orpie <Formula
  url 'http://pessimization.com/software/orpie/orpie-1.5.1.tar.gz'
  homepage 'http://pessimization.com/software/orpie/'
  md5 '4511626ed853354af1b4b5dbbf143a1f'

  depends_on 'gsl'
  depends_on 'objective-caml'

  def patches
    # cribbed from macports.org
    # I believe this covers up a problem with missing symbols
    # by falling back on ocaml's non-optimized byte-code interpreter.
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
      "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make install"
  end
end

__END__
--- orpie/Makefile.in.orig 2007-09-14 05:31:23.000000000 +0200
+++ orpie/Makefile.in 2009-09-03 00:21:43.000000000 +0200
@@ -24,12 +24,12 @@
 MANDIR      = $(DESTDIR)/@mandir@

 # other variables set by ./configure
-OCAMLC       = @OCAMLC@
-OCAMLOPT     = @OCAMLOPT@
+OCAMLC       = ocamlc
+OCAMLOPT     = no
 OCAMLDEP     = @OCAMLDEP@
 OCAMLLIB     = @OCAMLLIB@
-OCAMLBEST    = @OCAMLBEST@
-OCAMLLEX     = @OCAMLLEX@
+OCAMLBEST    = byte
+OCAMLLEX     = ocamllex
 OCAMLYACC    = @OCAMLYACC@
 OCAMLVERSION = @OCAMLVERSION@
 OCAMLWIN32   = @OCAMLWIN32@


