require 'formula'

class Libmikmod < Formula
  url 'https://github.com/mistydemeo/libmikmod.git', :tag => '446324a45a6d165b1941a4758f6cd221301b479e'
  homepage 'http://mikmod.raphnet.net/'
  version '3.2.0b2'

  def options
    [[ '--with-debug', 'Enable debugging symbols and build without optimization' ]]
  end

  def patches
    # When aclocal is run on configure.in, it is told to use a macro AM_PATH_ESD that
    # only exists if esound is installed.  Here CoreAudio is used not esound.
    DATA unless Formula.factory('esound').installed?
  end

  def install
    ENV.no_optimization if ARGV.include? '--with-debug'  # leave code unoptimzed 4 debug
    ENV['LIBTOOLIZE'] = '/usr/bin/glibtoolize'           # system libtoolize for autoreconf
    acpath = "#{HOMEBREW_PREFIX}/share/aclocal"          # esd.m4 if installed would be here
    ENV['ACLOCAL'] = "/usr/bin/aclocal -I #{acpath}" if Formula.factory('esound').installed?

    # Macports patched libmikmod-3.2.0-beta2.tar.bz2 in 2004.  Most of their work
    # was merged into the upstream source by 2005 when the devs moved to sourceforge.
    # Development stopped a year later, after many more bug fixes and improvements.
    # The version was never changed. It is still called 3.2.0b2 inside their code.
    # This formula builds 3.2.0b2 from cvs, the final libmikmod at this time.

    # The patch below is the only one from Macports the devs didn't merge.  It
    # prevents a crash on accessing the samples menu in Mikmod. Check if Samples[]
    # exists before letting the subsequent code try to access the array items.

    # Also in cvs is one error that stops the build.  Below is a new patch
    # that fixes the error when linking libmikmod.dylib, where the build outputs:
    #      ld: duplicate symbol _vc_callback in .libs/virtch2.o and .libs/virtch.o
    # Problem: vc_callback is declared twice globally and once as an extern.
    # Solution: Switch it to declared once globally and twice as extern.

    # And finally in cvs the function vc_callback() is defined to use unsigned char*.
    # With this patch, virtch2.c and virtch.c will use vc_callback() identically.

    inreplace 'playercode/virtch_common.c', '(handle<MAXSAMPLEHANDLES)',
                                            '(Samples && handle<MAXSAMPLEHANDLES)'

    inreplace 'playercode/mdriver.c', 'extern MikMod_callback_t vc_callback',
                                      'MikMod_callback_t vc_callback'
    inreplace 'playercode/virtch_common.c', 'MikMod_callback_t vc_callback',
                                            'extern MikMod_callback_t vc_callback'

    inreplace 'playercode/virtch2.c', 'vc_callback((char*)vc_tickbuf, portion)',
                                      'vc_callback((unsigned char*)vc_tickbuf, portion)'


    # OSX has CoreAudio, but ALSA is not for this OS nor is SAM9407 nor ULTRA.
    # The osx and x11 tests may work automatically. They are explicit to be thorough.
    args = ["--prefix=#{prefix}",
            "--mandir=#{man}",
            "--infodir=#{info}",
            "--disable-alsa",
            "--disable-sam9407",
            "--disable-ultra",
            "--enable-osx",
            "--with-x",
            "--x-includes=/usr/X11/include",
            "--x-libraries=/usr/X11/lib"]
    args << ((ARGV.include? '--with-debug') ? '--enable-debug' : '--disable-debug')
    # autoreconf w/glibtoolize will fix PIC flags, flat_namespace from 2005 era code.
    system "autoreconf -ivf"
    # An oos build is recommended in the documentation.
    Dir.mkdir 'macbuild'
    Dir.chdir 'macbuild' do
      system "../configure", *args
      system "make"
      system "make install"
    end
  end
end

__END__
--- a/configure.in	2007-12-03 12:50:05.000000000 -0800
+++ b/configure.in	2011-11-18 22:08:41.000000000 -0800
@@ -331,7 +331,6 @@
 if test $libmikmod_driver_esd = yes
 then
 	libmikmod_driver_esd=no
-	AM_PATH_ESD(0.2.6,libmikmod_driver_esd=yes)
 # We also need to know if esd is compiled with alsa support
 	if test $libmikmod_driver_esd = yes
 	then
