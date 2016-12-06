require 'formula'

class Snid < Formula
  url 'http://marwww.in2p3.fr/~blondin/software/snid/snid-5.0.tar.gz'
  homepage 'http://marwww.in2p3.fr/~blondin/software/snid/'
  md5 'aefed2e2cbd5b26fd1f0171bbb7b6092'

  depends_on 'pgplot'

  def patches () DATA end

  def install
    ENV.fortran
    ENV.x11
    # where to store spectral templates
    inreplace 'source/snidmore.f', 'INSTALL_DIR/snid-5.0', prefix
    ENV.append 'FFLAGS', '-O -fno-automatic'
    ENV['PGLIBS'] = "-Wl,-framework -Wl,Foundation -L#{HOMEBREW_PREFIX}/lib -lpgplot"
    system "make"
    bin.install 'snid', 'logwave', 'plotlnw'
    prefix.install Dir['templates']
    prefix.install Dir['test']
    doc.install Dir['doc/*']
  end

  def test
    mktemp do
      system "snid wmin=4300 wmax=8900 #{prefix}/test/sn2003jo.dat"
    end

  end
end

__END__
diff --git a/Makefile b/Makefile
index 23a9864..ded9835 100644
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
