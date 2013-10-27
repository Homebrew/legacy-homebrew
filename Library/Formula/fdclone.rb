require 'formula'

class Fdclone < Formula
  homepage 'http://hp.vector.co.jp/authors/VA012337/soft/fd/'
  url 'http://hp.vector.co.jp/authors/VA012337/soft/fd/FD-3.01a.tar.gz'
  sha1 '5d4f90ccaee67fadcc5d776f90bbe2fd760c4cdd'

  depends_on 'nkf' => :build

  def patches
    DATA
  end

  def install
    ENV.j1
    system "make", "PREFIX=#{prefix}", "all"
    system "make", "MANTOP=#{man}", "install"

    %w(README FAQ HISTORY LICENSES TECHKNOW ToAdmin).each do |file|
      system "nkf", "-w", "--overwrite", file
      prefix.install "#{file}.eng" => file
      prefix.install file => "#{file}.ja"
    end

    share.install "_fdrc" => "fd2rc.dist"
  end

  def caveats; <<-EOS.undent
    To install the initial config file:
        install -c -m 0644 #{share}/fd2rc.dist ~/.fd2rc
    To set application messages to Japanese, edit your .fd2rc:
        MESSAGELANG="ja"
    EOS
  end
end

__END__
diff --git a/machine.h b/machine.h
index 8bc70ab..39b0d28 100644
--- a/machine.h
+++ b/machine.h
@@ -1449,4 +1449,6 @@ typedef unsigned long		u_long;
 #define	GETTODARGS		2
 #endif

+#define USEDATADIR
+
 #endif	/* !__MACHINE_H_ */
diff --git a/custom.c b/custom.c
index d7a995f..45b96c6 100644
--- a/custom.c
+++ b/custom.c
@@ -561,7 +561,7 @@ static CONST envtable envlist[] = {
 	{"FD_URLKCODE", &urlkcode, DEFVAL(NOCNV), URLKC_E, T_KNAM},
 #endif
 #if	!defined (_NOENGMES) && !defined (_NOJPNMES)
-	{"FD_MESSAGELANG", &messagelang, DEFVAL(NOCNV), MESL_E, T_MESLANG},
+	{"FD_MESSAGELANG", &messagelang, DEFVAL("C"), MESL_E, T_MESLANG},
 #endif
 #ifdef	DEP_FILECONV
 	{"FD_SJISPATH", &sjispath, DEFVAL(SJISPATH), SJSP_E, T_KPATHS},
@@ -857,7 +857,9 @@ int no;
 #if	defined (DEP_KCONV) || (!defined (_NOENGMES) && !defined (_NOJPNMES))
 		case T_MESLANG:
 # ifndef	_NOCATALOG
+			if (!cp) cp = def_str(no);
 			catname = cp;
+			chkcatalog();
 /*FALLTHRU*/
 # endif
 		case T_KIN:
