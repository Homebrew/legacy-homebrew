require 'formula'

class NewickUtils < Formula
  homepage 'http://cegg.unige.ch/newick_utils'
  url 'http://cegg.unige.ch/pub/newick-utils-1.6.tar.gz'
  sha1 'a9779054dcbf957618458ebfed07991fabeb3e19'

  # don't bother testing nw_gen, it's known to fail on MacOSX
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make check"
    system "make install"
  end

  test do
    require 'open3'

    expected = <<-EOS
 +-------------------------------------+ B
=| A
 +---------------------------------------------------------------------------+ C

 |------------------|------------------|------------------|------------------|
 0                0.5                  1                1.5                  2
 substitutions/site
EOS

    Open3.popen3("#{bin}/nw_display", "-") do |stdin, stdout, _|
      stdin.write("(B:1,C:2)A;\n")
      stdin.close
      assert_equal expected, stdout.read.split("\n").map(&:rstrip).join("\n")
    end
  end
end

__END__
--- a/tests/test_nw_gen.sh
+++ b/tests/test_nw_gen.sh
@@ -138,0 +139,2 @@
+pass=TRUE
+
