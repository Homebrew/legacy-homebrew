require 'formula'

class Bigflex < Formula
  homepage 'http://flex.sourceforge.net/'
  url 'http://download.sourceforge.net/project/flex/flex/flex-2.5.35/flex-2.5.35.tar.bz2'
  sha1 'c507095833aaeef2d6502e12638e54bf7ad2f24a'

  def set_bigflex_tmpdir(tmpdir)
    @bf_tmpdir = tmpdir
  end

  def patches
    # increase flex state limits for morpha
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{@bf_tmpdir}"
    system "make install"
  end
end

class Morpha < Formula
  homepage 'http://www.informatics.susx.ac.uk/research/groups/nlp/carroll/morph.html'
  url 'http://www.informatics.sussex.ac.uk/research/groups/nlp/carroll/morph.tar.gz'
  sha1 '814915da6cb151cfbf48353c0ab00fcad6ddf122'
  version '20030908'

  # Must have gawk to build morphg.
  # The Mac OS X system version of awk doesn't work.
  depends_on 'gawk' => :build

  def install
    morpha_path = Pathname.pwd
    # install bigflex into a temporary directory
    mktemp do
      bigflex_path = Pathname.pwd
      bigflex = Bigflex.new('bigflex')
      bigflex.brew {
        bigflex.set_bigflex_tmpdir(bigflex_path)
        bigflex.install
      }

      chdir morpha_path

      inreplace 'morpha.lex', '"verbstem.list"', "\"#{share}/verbstem.list\""
      inreplace 'Makefile', '#CCOPT = -O -Dinteractive',
                            'CCOPT = -O -Dinteractive'
      inreplace 'Makefile', 'FLEX=./bigflex', "FLEX=#{bigflex_path}/bin/flex"

      # call make to build
      system "make", 'morpha', 'morphg'

      bin.install 'morpha', 'morphg'
      share.install 'verbstem.list'
      doc.install 'minnen.pdf', 'doc.txt'
    end
  end
end

__END__
diff --git a/flexdef.h b/flexdef.h
index d038952..a16e8ba 100644
--- a/flexdef.h
+++ b/flexdef.h
@@ -241,10 +241,10 @@ char *alloca ();
 #define INITIAL_MAX_DFAS 1000	/* default maximum number of dfa states */
 #define MAX_DFAS_INCREMENT 1000

-#define JAMSTATE -32766		/* marks a reference to the state that always jams */
+#define JAMSTATE -800000		/* marks a reference to the state that always jams */

 /* Maximum number of NFA states. */
-#define MAXIMUM_MNS 31999
+#define MAXIMUM_MNS 800000
 #define MAXIMUM_MNS_LONG 1999999999

 /* Enough so that if it's subtracted from an NFA state number, the result
@@ -336,7 +336,7 @@ char *alloca ();
 /* Number that, if used to subscript an array, has a good chance of producing
  * an error; should be small enough to fit into a short.
  */
-#define BAD_SUBSCRIPT -32767
+#define BAD_SUBSCRIPT -800000

 /* Absolute value of largest number that can be stored in a short, with a
  * bit of slop thrown in for general paranoia.
