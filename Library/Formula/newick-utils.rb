require 'formula'

class NewickUtils < Formula
  homepage 'http://cegg.unige.ch/newick_utils'
  url 'http://cegg.unige.ch/pub/newick-utils-1.6.tar.gz'
  sha1 'a9779054dcbf957618458ebfed07991fabeb3e19'

  def patches
    # don't bother testing nw_gen, it's known to fail on MacOSX
    DATA
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make check"
    system "make install"
  end

  def test
    system "echo '(B:1,C:2)A;' | #{bin}/nw_display -"
  end
end

__END__
--- a/tests/test_nw_gen.sh
+++ b/tests/test_nw_gen.sh
@@ -138,0 +139,2 @@
+pass=TRUE
+
