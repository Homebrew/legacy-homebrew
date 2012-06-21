require 'formula'

class CmuPocketsphinx < Formula
  homepage 'http://cmusphinx.sourceforge.net/'
  url 'http://sourceforge.net/projects/cmusphinx/files/pocketsphinx/0.7/pocketsphinx-0.7.tar.gz'
  sha1 '4140245211239d8922543b28007fc5afd77258fe'

  depends_on 'pkg-config' => :build
  depends_on 'cmu-sphinxbase'

  # Fix compilation with clang; already upstream, and can be removed in
  # next version.
  def patches
    DATA
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/src/libpocketsphinx/fsg_search.c b/src/libpocketsphinx/fsg_search.c
index 449b819..3223be1 100644
--- a/src/libpocketsphinx/fsg_search.c
+++ b/src/libpocketsphinx/fsg_search.c
@@ -260,7 +260,7 @@ fsg_search_reinit(ps_search_t *search, dict_t *dict, dict2pid_t *d2p)
     
     /* Nothing to update */
     if (fsgs->fsg == NULL)
-	return;
+	return 0;
 
     /* Update the number of words (not used by this module though). */
     search->n_words = dict_size(dict);
diff --git a/src/libpocketsphinx/ngram_search.c b/src/libpocketsphinx/ngram_search.c
index cb6463d..91541c4 100644
--- a/src/libpocketsphinx/ngram_search.c
+++ b/src/libpocketsphinx/ngram_search.c
@@ -279,7 +279,7 @@ ngram_search_reinit(ps_search_t *search, dict_t *dict, dict2pid_t *d2p)
     ps_search_base_reinit(search, dict, d2p);
     
     if (ngs->lmset == NULL)
-	return;
+	return 0;
 
     /* Update beam widths. */
     ngram_search_calc_beams(ngs);
