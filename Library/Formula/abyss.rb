require 'formula'

class Abyss < Formula
  homepage 'http://www.bcgsc.ca/platform/bioinfo/software/abyss'
  url 'http://www.bcgsc.ca/downloads/abyss/abyss-1.3.2.tar.gz'
  md5 'a7551c95f33a0c61cab50bc35db347e4'

  depends_on 'boost' => :build
  depends_on 'google-sparsehash' => :build
  depends_on 'open-mpi'

  # strip breaks the ability to read compressed files.
  skip_clean 'bin'

  def patches
    # abyss-overlap does not build with LLVM-GCC
    DATA
  end

  def install
    system "./configure", "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/ABYSS --version"
  end
end

__END__
diff --git a/Map/Makefile.in b/Map/Makefile.in
index 7a4e5a8..4dd5dd5 100644
--- a/Map/Makefile.in
+++ b/Map/Makefile.in
@@ -32,8 +32,7 @@ POST_INSTALL = :
 NORMAL_UNINSTALL = :
 PRE_UNINSTALL = :
 POST_UNINSTALL = :
-bin_PROGRAMS = abyss-index$(EXEEXT) abyss-map$(EXEEXT) \
-	abyss-overlap$(EXEEXT)
+bin_PROGRAMS = abyss-index$(EXEEXT) abyss-map$(EXEEXT)
 subdir = Map
 DIST_COMMON = $(srcdir)/Makefile.am $(srcdir)/Makefile.in
 ACLOCAL_M4 = $(top_srcdir)/aclocal.m4
