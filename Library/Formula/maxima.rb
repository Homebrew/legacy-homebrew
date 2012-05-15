require 'formula'

class Maxima < Formula
  url 'http://sourceforge.net/projects/maxima/files/Maxima-source/5.25.1-source/maxima-5.25.1.tar.gz'
  homepage 'http://maxima.sourceforge.net/'
  md5 'f2a7399e53eadc38e0bedb843d5d7055'

  depends_on 'gettext'
  depends_on 'sbcl'
  depends_on 'gnuplot'
  depends_on 'rlwrap'

  def patches
    # fixes 3468021: imaxima.el uses incorrect tmp directory on OS X:
    # https://sourceforge.net/tracker/?func=detail&aid=3468021&group_id=4933&atid=104933
    DATA
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}", "--infodir=#{info}",
                          "--enable-sbcl", "--enable-gettext"
    system "make"
    system "make check"
    system "make install"
  end

  def test
    system "#{bin}/maxima", "--batch-string='run_testsuite(); quit();'"
  end
end

__END__
diff --git a/interfaces/emacs/imaxima/imaxima.el b/interfaces/emacs/imaxima/imaxima.el
index e3feaa6..3a52a0b 100644
--- a/interfaces/emacs/imaxima/imaxima.el
+++ b/interfaces/emacs/imaxima/imaxima.el
@@ -296,6 +296,8 @@ nil means no scaling at all, t allows any scaling."
 	 (temp-directory))
 	((eql system-type 'cygwin)
 	 "/tmp/")
+	((eql system-type 'darwin)
+	 "/tmp/")
 	(t temporary-file-directory))
   "*Directory used for temporary TeX and image files."
   :type '(directory)
