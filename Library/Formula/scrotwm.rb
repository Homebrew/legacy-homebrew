require 'formula'

class Scrotwm < Formula
  url 'http://opensource.conformal.com/snapshots/scrotwm/scrotwm-0.9.30.tgz'
  homepage 'http://opensource.conformal.com/wiki/scrotwm'
  md5 '008d018a0ab546b4915e5aa7199f8982'

  def patches
    DATA
  end

  def install
    Dir.chdir "osx"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats; <<-EOS
    To use scrotwm as your X window manager, create or edit  ~/.xinitrc and add:
      exec #{HOMEBREW_PREFIX}/bin/scrotwm
    EOS
  end
end

__END__
# osx.h is missing a macro for TAIL_END (which is defined for Linux)
--- a/osx/osx.h
+++ b/osx/osx.h
@@ -1,3 +1,8 @@
 /* $scrotwm: osx.h,v 1.1 2009/11/25 16:12:13 marco Exp $ */

 long long strtonum(const char *, long long, long long, const char **);
+
+#ifndef TAILQ_END
+#define	TAILQ_END(head)			NULL
+#endif
