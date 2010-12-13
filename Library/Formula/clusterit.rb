require 'formula'

class Clusterit <Formula
  url 'http://downloads.sourceforge.net/project/clusterit/clusterit/clusterit-2.5/clusterit-2.5.tar.gz'
  homepage 'http://www.garbled.net/clusterit.html'
  md5 'f0e772e07122e388de629fb57f7237ab'

  def patches
      DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end


__END__
diff --git a/Makefile.am b/Makefile.am
index 63f334e..a7ee923 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,2 +1,2 @@
 #SUBDIRS = dsh html pcp rvt barrier common dvt jsd regress tools catman
-SUBDIRS = barrier dsh dvt jsd pcp rvt dtop tools
+SUBDIRS = barrier dsh jsd pcp dtop tools

