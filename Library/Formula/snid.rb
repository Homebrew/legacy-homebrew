require 'formula'

class SnidTemplates < Formula
  url 'http://www.oamp.fr/people/blondin/software/snid/templates-2.0.tgz'
  sha1 '1e5c33ee998203abc171e7fdda7114a27130d418'
end

class SnidBSNIPTemplates < Formula
  url 'http://hercules.berkeley.edu/database/BSNIPI/bsnip_v7_snid_templates.tar.gz'
  sha1 '1d1d2534d9201c864ad60e58acf6337cec0700e2'
end

class Snid < Formula
  homepage 'http://www.oamp.fr/people/blondin/software/snid/'
  url 'http://www.oamp.fr/people/blondin/software/snid/snid-5.0.tar.gz'
  sha1 '0ba81c23584388065169b88bf54a9c3975b12460'

  depends_on :x11
  depends_on 'pgplot' => 'with-button'

  # no libbutton compilation and patch for new templates
  # as per http://www.oamp.fr/people/blondin/software/snid/README_templates-2.0
  def patches; DATA; end

  def install
    ENV.fortran

    # new templates
    SnidTemplates.new.brew do
      prefix.install '../templates-2.0'
    end
    # BSNIP
    SnidBSNIPTemplates.new.brew do
      safe_system 'ls *.lnw > templist'
      cp "#{buildpath}/templates/texplist", '.'
      cp "#{buildpath}/templates/tfirstlist", '.'
      (prefix + 'templates_bsnip_v7.0').install Dir['*']
    end

    cp 'source/snid.inc', '.'
    # where to store spectral templates
    inreplace 'source/snidmore.f', 'INSTALL_DIR/snid-5.0/templates', "#{prefix}/templates-2.0"

    ENV.append 'FCFLAGS', '-O -fno-automatic'
    ENV['PGLIBS'] = "-Wl,-framework -Wl,Foundation -L#{HOMEBREW_PREFIX}/lib -lpgplot"
    system 'make'
    bin.install 'snid', 'logwave', 'plotlnw'
    prefix.install 'templates', 'test'
    doc.install Dir['doc/*']
  end

  test do
    system "#{bin}/snid inter=0 plot=0 #{prefix}/test/sn2003jo.dat"
  end
end

__END__
--- a/Makefile
+++ b/Makefile
@@ -167,12 +167,11 @@ OUTILS2= utils/lnb.o utils/median.o
 OUTILS3= utils/four2.o utils/lnb.o
 
 # Button library
-BUTTLIB= button/libbutton.a
+BUTTLIB= -lbutton
 
 all : snid logwave plotlnw
 
 snid :  $(OBJ1) $(OUTILS1)
-	cd button && $(MAKE) FC=$(FC)
 	$(FC) $(FFLAGS) $(OBJ1) $(OUTILS1) $(XLIBS) $(BUTTLIB) $(PGLIBS) -o $@
 
 logwave : $(OBJ2) $(OUTILS2)
--- a/source/typeinfo.f
+++ b/source/typeinfo.f
@@ -48,6 +48,8 @@
       typename(1,4) = 'Ia-91bg'
       typename(1,5) = 'Ia-csm'
       typename(1,6) = 'Ia-pec'
+      typename(1,7) = 'Ia-99aa'
+      typename(1,8) = 'Ia-02cx'
 * SN Ib      
       typename(2,1) = 'Ib'
       typename(2,2) = 'Ib-norm'
@@ -70,6 +72,8 @@
       typename(5,3) = 'Gal'
       typename(5,4) = 'LBV'
       typename(5,5) = 'M-star'
+      typename(5,6) = 'C-star'
+      typename(5,7) = 'QSO'
 
       return
       end
--- a/source/snid.inc
+++ b/source/snid.inc
@@ -44,16 +44,16 @@
       parameter (MAXPARAM = 200)
       parameter (MAXPEAK = 20)
       parameter (MAXPLOT = 20)
-      parameter (MAXPPT = 20000)
+      parameter (MAXPPT = 50000)
       parameter (MAXR = 999.9)
       parameter (MAXRLAP = 999)
       parameter (MAXSN = 300)
       parameter (MAXUSE = 30)
-      parameter (MAXTEMP = 3000)
+      parameter (MAXTEMP = 10000)
       parameter (MAXTOK = 32)
       parameter (MAXWAVE = 10000)
       parameter (NT = 5)
-      parameter (NST = 6)
+      parameter (NST = 8)
 
       character*10 typename(NT,NST) ! character array containing type/subtype names
 
