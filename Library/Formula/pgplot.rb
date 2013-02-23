require 'formula'

class Button < Formula
  url 'http://www.ucm.es/info/Astrof/software/button/button.tar.gz'
  sha1 'd1bfcb51a9ce5819e00d5d1a1d8c658691193f11'
  version '1.0'
end

class Pgplot < Formula
  homepage 'http://www.astro.caltech.edu/~tjp/pgplot/'
  url 'ftp://ftp.astro.caltech.edu/pub/pgplot/pgplot522.tar.gz'
  version '5.2.2'
  sha1 '1f1c9aa17eeec9a2fb23fd15a0e4a91dcc49ddc1'

  option 'with-button', 'Install libbutton'

  depends_on :x11

  def patches
    # from MacPorts: https://trac.macports.org/browser/trunk/dports/graphics/pgplot/files
    {:p0 => [
     "https://trac.macports.org/export/89961/trunk/dports/graphics/pgplot/files/patch-makemake.diff",
     "https://trac.macports.org/export/89961/trunk/dports/graphics/pgplot/files/patch-proccom.c.diff",
    ]}
  end

  def install
    ENV.deparallelize
    ENV.fortran
    ENV.append 'CPPFLAGS', "-DPG_PPU"
    # allow long lines in the fortran code (for long homebrew PATHs)
    ENV.append 'FCFLAGS', "-ffixed-line-length-none"

    # re-hardcode the share dir
    inreplace 'src/grgfil.f', '/usr/local/pgplot', share
    # perl may not be in /usr/local
    inreplace 'makehtml', '/usr/local/bin/perl', `which perl`.chomp
    # prevent a "dereferencing pointer to incomplete type" in libpng
    inreplace 'drivers/pndriv.c', 'setjmp(png_ptr->jmpbuf)', 'setjmp(png_jmpbuf(png_ptr))'

    # configure options
    mkdir 'sys_darwin' do
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

    mkdir 'build' do
      # activate drivers
      cp '../drivers.list', '.'
      ['GIF', 'VGIF', 'LATEX', 'PNG' ,'TPNG', 'PS',
       'VPS', 'CPS', 'VCPS', 'XWINDOW', 'XSERVE'].each do |drv|
        inreplace 'drivers.list', /^! (.*\/#{drv} .*)/, '  \1'
      end

      # make everything
      system '../makemake .. darwin; make; make cpg; make pgplot.html'

      # install
      bin.install 'pgxwin_server', 'pgbind'
      lib.install Dir['*.dylib', '*.a']
      include.install Dir['*.h']
      share.install Dir['*.txt', '*.dat']
      doc.install Dir['*.doc', '*.html']
      (prefix/'examples').install Dir['*demo*', '../examples/pgdemo*.f', '../cpg/cpgdemo*.c', '../drivers/*/pg*demo.*']
    end

    # install libbutton
    if build.include? 'with-button'
      Button.new.brew do
        inreplace 'Makefile', 'f77', "#{ENV['FC']} #{ENV['FCFLAGS']}"
        system "make"
        lib.install 'libbutton.a'
      end
    end
  end

  test do
    File.open('test_pgplot', 'w') do |t|
      t.write(<<-EOS
spawn #{prefix}/examples/pgdemo1
expect {
  NULL     {send "/XWINDOW\n"; exp_continue}
  RETURN   {send "\n"; exp_continue}
}
EOS
              )
    end
    system "expect test_pgplot; killall pgxwin_server"
  end
end
