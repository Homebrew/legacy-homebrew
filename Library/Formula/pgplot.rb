require 'formula'

class Button < Formula
  url 'http://www.ucm.es/info/Astrof/software/button/button.tar.gz'
  md5 'f4b058b59b5903956e3e30ed1b5d4aa0'
  version '1.0'
end

class Pgplot < Formula
  url 'ftp://ftp.astro.caltech.edu/pub/pgplot/pgplot522.tar.gz'
  homepage 'http://www.astro.caltech.edu/~tjp/pgplot/'
  md5 'e8a6e8d0d5ef9d1709dfb567724525ae'
  version '5.2.2'

  def patches
    {:p0 => [
             # from MacPorts: https://trac.macports.org/browser/trunk/dports/graphics/pgplot/files
             "https://trac.macports.org/export/89961/trunk/dports/graphics/pgplot/files/patch-makemake.diff",
             "https://trac.macports.org/export/89961/trunk/dports/graphics/pgplot/files/patch-proccom.c.diff",
            ],
      :p1 => DATA}
  end

  def install
    ENV.deparallelize
    ENV.x11
    ENV.fortran
    ENV.append 'CPPFLAGS', "-DPG_PPU"

    # re-hardcode the share dir
    inreplace 'src/grgfil.f', '/usr/local/pgplot', share

    # configure options
    mkdir 'sys_darwin'
    cd 'sys_darwin' do
      File.open('homebrew.conf', 'w') do |conf|
        conf.write(<<-EOS
XINCL="#{ENV.cppflags}"
MOTIF_INCL=""
ATHENA_INCL=""
TK_INCL=""
RV_INCL=""
FCOMPL="#{ENV['FC']}"
FFLAGC="#{ENV['FCFLAGS']}"
FFLAGD=""
CCOMPL="#{ENV.cc}"
CFLAGC="#{ENV.cppflags}"
CFLAGD=""
PGBIND_FLAGS="bsd"
LIBS="#{ENV.ldflags} -lX11"
MOTIF_LIBS=""
ATHENA_LIBS=""
TK_LIBS=""
RANLIB="#{`which ranlib`.chomp}"
SHARED_LIB="libpgplot.dylib"
SHARED_LD="#{ENV['FC']} -dynamiclib -single_module $LDFLAGS -lX11 -install_name libpgplot.dylib"
SHARED_LIB_LIBS="#{ENV.ldflags} -lpng -lX11"
MCOMPL=""
MFLAGC=""
SYSDIR="$SYSDIR"
CSHARED_LIB="libcpgplot.dylib"
CSHARED_LD="#{ENV['FC']} -dynamiclib -single_module $LDFLAGS -lX11"
EOS
                   )
      end
    end

    mkdir 'build'
    cd 'build' do
      # activate drivers
      cp '../drivers.list', '.'
      ['GIF', 'VGIF', 'LATEX', 'PNG' ,'TPNG', 'PS',
       'VPS', 'CPS', 'VCPS', 'XWINDOW', 'XSERVE'].each do |drv|
        inreplace 'drivers.list', /^! (.*\/#{drv} .*)/, '  \1'
      end
      # make everything
      system '../makemake .. darwin; make; make cpg; make pgplot.html'
      # install
      bin.install ['pgxwin_server', 'pgbind']
      lib.install Dir['*.dylib', '*.a']
      include.install Dir['*.h']
      share.install Dir['*.txt', '*.dat']
      doc.install Dir['*.doc', '*.html']
      examples = prefix + 'examples'
      examples.mkpath
      examples.install Dir['*demo*', '../examples/pgdemo*.f', '../cpg/cpgdemo*.c', '../drivers/*/pg*demo.*']
    end

    # install libbutton
    Button.new.brew do
      inreplace 'Makefile', 'f77', ENV['FC']
      system "make"
      lib.install 'libbutton.a'
    end
  end

  def test
    system "#{prefix}/examples/pgdemo1"
  end
end

__END__
diff --git a/drivers/pndriv.c b/drivers/pndriv.c
index 2b2f87d..89f55fb 100644
--- a/drivers/pndriv.c
+++ b/drivers/pndriv.c
@@ -222,7 +222,7 @@ static void write_image_file(DeviceData *dev) {
 	return;
   }
 
-  if (setjmp(png_ptr->jmpbuf)) { /* not really sure what I'm doing here... */
+  if (png_jmpbuf(png_ptr)) { /* not really sure what I'm doing here... */
 	fprintf(stderr,"%s: error in libpng while writing file %s, plotting disabled\n", png_ident, filename);
 	png_destroy_write_struct(&png_ptr,&info_ptr);
 	dev->error = true;
diff --git a/makehtml b/makehtml
index 2222600..08d0494 100755
--- a/makehtml
+++ b/makehtml
@@ -1,4 +1,4 @@
-#!/usr/local/bin/perl
+#!/usr/bin/perl
 
 $, = ' ';		# set output field separator
 $\ = "\n";		# set output record separator
