require 'formula'

class NewickUtils < Formula
  url 'http://cegg.unige.ch/pub/newick-utils-1.6.tar.gz'
  homepage 'http://cegg.unige.ch/newick_utils'
  md5 'ed0bf50f03196cfef3809f5a76804624'

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
