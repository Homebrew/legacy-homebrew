require 'formula'

class Nvi < Formula
  homepage 'https://sites.google.com/a/bostic.com/keithbostic/nvi'
  url 'http://www.kotnet.org/~skimo/nvi/devel/nvi-1.81.6.tar.bz2'
  md5 '88d1e23115ee9f2961186b62e55f5704'

  depends_on 'berkeley-db'

  skip_clean :all

  def patches
    DATA
  end

  def install
    cd 'dist' do
      system "./configure", "--prefix=#{prefix}",
                            "--program-prefix=n",
                            "--disable-dependency-tracking"
      system "make"
      ENV.j1
      system "make install"
    end
  end
end

__END__
diff --git a/ex/ex_script.c b/ex/ex_script.c
index 31f42c1..8f0104a 100644
--- a/ex/ex_script.c
+++ b/ex/ex_script.c
@@ -12,6 +12,10 @@

 #include "config.h"

+#ifdef __APPLE__
+#undef HAVE_SYS5_PTY
+#endif
+
 #ifndef lint
 static const char sccsid[] = "$Id: ex_script.c,v 10.38 2001/06/25 15:19:19 skimo Exp $ (Berkeley) $Date: 2001/06/25 15:19:19 $";
 #endif /* not lint */
@@ -45,6 +49,10 @@ static const char sccsid[] = "$Id: ex_script.c,v 10.38 2001/06/25 15:19:19 skimo
 #include "script.h"
 #include "pathnames.h"

+#ifdef __APPLE__
+#undef HAVE_SYS5_PTY
+#endif
+
 static void	sscr_check __P((SCR *));
 static int	sscr_getprompt __P((SCR *));
 static int	sscr_init __P((SCR *));
