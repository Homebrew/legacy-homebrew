require 'formula'

class Genstats < Formula
  homepage 'http://www.vanheusden.com/genstats/'
  url 'http://www.vanheusden.com/genstats/genstats-1.0.0.tgz'
  sha1 '8ca19e5fe72f1d881bf38298e155b15f07e6bd66'

  def patches
    # fix compile errors on OS X for 1.0.0. I've emailed the author.
    DATA
  end

  def install
    # Tried to make this a patch.  Applying the patch hunk would
    # fail, even though I used "git diff | pbcopy".  Tried messing
    # with whitespace, # lines, etc.  Ugh.
    inreplace 'br.cpp' do |s|
      s.gsub! /if \(_XOPEN_VERSION >= 600\)/, 'if (_XOPEN_VERSION >= 600) && !__APPLE__'
    end

    system 'make'
    bin.install('genstats')
    man.install('genstats.1')
  end

  def test
    # TODO(dan): be more thorough
    system "genstats -h | grep folkert@vanheusden.com"
  end
end
__END__
diff --git a/br.h b/br.h
index addf8bc..dfdb5d4 100644
--- a/br.h
+++ b/br.h
@@ -8,6 +8,14 @@
 #define likely(x)       __builtin_expect((x),1)
 #define unlikely(x)     __builtin_expect((x),0)
 
+#ifdef __APPLE__
+/* See http://fixunix.com/bsd/539901-definition-off64_t.html */
+typedef off_t off64_t;
+/* See http://lists.apple.com/archives/unix-porting/2002/Jul/msg00099.html */
+#define lseek64 lseek
+#define open64 open
+#endif
+
 class buffered_reader
   {
 private:
