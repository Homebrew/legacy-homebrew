require 'formula'

class Vcftools < Formula
  url 'http://downloads.sourceforge.net/project/vcftools/vcftools_0.1.7.tar.gz'
  homepage 'http://vcftools.sourceforge.net/index.html'
  md5 'd3e68027a7fe40d3f8cb28c3006c7248'

  def patches
    # Install Perl modules to /lib/perl5/site_perl and ensure VcfStats.pm is installed
    # This is fixed in vcf source tree, will not be needed after version 0.1.7
    DATA
  end

  def install
    system "make install PREFIX=#{prefix} CPP=#{ENV.cxx}"
  end

  def test
    system "vcftools"
  end

  def caveats; <<-EOS.undent
    To use the Perl modules, make sure Vcf.pm, VcfStats.pm, and FaSlice.pm
    are included in your PERL5LIB environment variable:
      export PERL5LIB=#{HOMEBREW_PREFIX}/lib/perl5/site_perl:${PERL5LIB}
    EOS
  end
end

__END__
diff --git a/Makefile b/Makefile
index 39c042b..055afd0 100644
--- a/Makefile
+++ b/Makefile
@@ -17,7 +17,7 @@ ifndef PREFIX
     export PREFIX = $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
 endif
 export BINDIR = ${PREFIX}/bin
-export MODDIR = ${PREFIX}/lib
+export MODDIR = ${PREFIX}/lib/perl5/site_perl
 
 DIRS = cpp perl
 install:

diff --git a/perl/Makefile b/perl/Makefile
index 222b75d..2e8b49f 100644
--- a/perl/Makefile
+++ b/perl/Makefile
@@ -1,7 +1,7 @@
 
 BIN = vcf-compare fill-aa vcf-annotate vcf-merge vcf-isec vcf-stats vcf-to-tab fill-an-ac \
     vcf-query vcf-convert vcf-subset vcf-validator vcf-concat vcf-sort
-MOD = FaSlice.pm Vcf.pm
+MOD = FaSlice.pm Vcf.pm VcfStats.pm
 
 install:
 	    @for i in $(BIN); do cp $(CURDIR)/$$i $(BINDIR)/$$i; done; \
