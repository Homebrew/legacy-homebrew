require 'formula'

class Opendetex < Formula
  homepage 'https://code.google.com/p/opendetex/'
  url 'https://opendetex.googlecode.com/files/opendetex-2.8.1.tar.bz2'
  sha1 'a811635519dc6573735ca9d406f7032eccacd7e0'

  patch :DATA

  def install
    system 'make'
    bin.install 'detex'
    bin.install 'delatex'
    man1.install 'detex.1l' => 'detex.1'
  end
end

__END__
diff --git a/detex.1l b/detex.1l
index a70c813..7033b44 100644
--- a/detex.1l
+++ b/detex.1l
@@ -1,4 +1,4 @@
-.TH DETEX 1L "12 August 1993" "Purdue University"
+.TH DETEX 1 "12 August 1993" "Purdue University"
 .SH NAME
 detex \- a filter to strip \fITeX\fP commands from a .tex file.
 .SH SYNOPSIS
@@ -103,7 +103,7 @@ The old functionality can be essentially duplicated by using the
 .B \-s
 option.
 .SH SEE ALSO
-tex(1L)
+tex(1)
 .SH DIAGNOSTICS
 Nesting of \\input is allowed but the number of opened files must not
 exceed the system's limit on the number of simultaneously opened files.
