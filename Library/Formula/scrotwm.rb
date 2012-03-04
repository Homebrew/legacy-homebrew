require 'formula'

class Scrotwm < Formula
  homepage 'http://opensource.conformal.com/wiki/scrotwm'
  url 'http://opensource.conformal.com/snapshots/scrotwm/scrotwm-0.9.30.tgz'
  md5 '008d018a0ab546b4915e5aa7199f8982'

  def patches
    DATA
  end

  def install
    cd "osx" do
      system "make"
      system "make", "install", "PREFIX=#{prefix}"
    end
  end

  def caveats; <<-EOS
    To use scrotwm as your X window manager, create or edit  ~/.xinitrc and add:
      exec #{HOMEBREW_PREFIX}/bin/scrotwm
    EOS
  end
end

__END__
# osx.h is missing a macro for TAIL_END (which is defined for Linux)
--- a/osx/osx.h	2011-06-14 10:51:33.000000000 -0500
+++ b/osx/osx.h	2011-08-14 14:05:58.000000000 -0500
@@ -1,3 +1,7 @@
 /* $scrotwm: osx.h,v 1.1 2009/11/25 16:12:13 marco Exp $ */
 
 long long strtonum(const char *, long long, long long, const char **);
+
+#ifndef TAILQ_END
+#define TAILQ_END(head)		NULL
+#endif
