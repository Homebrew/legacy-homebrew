require 'formula'

class Ghostscript < Formula
  homepage 'http://www.ghostscript.com/'
  url 'http://downloads.ghostscript.com/public/ghostscript-9.10.tar.gz'
  sha1 '29d6538ae77565c09f399b06455e94e7bcd83d01'

  bottle do
    sha1 "be9d9be82c03ac8409994fee0cc638d20ceb145c" => :mavericks
    sha1 "667bbb27e64fee6d46da07c98205a6daf51a28ad" => :mountain_lion
    sha1 "fb6e8756db2016f88eeb23ed392a9742096efef3" => :lion
  end

  head do
    url 'git://git.ghostscript.com/ghostpdl.git'

    resource 'djvu' do
      url 'git://git.code.sf.net/p/djvu/gsdjvu-git'
    end

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  option 'with-djvu', 'Build drivers for DjVU file format'

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'jbig2dec'
  depends_on 'little-cms2'
  depends_on :libpng
  depends_on :x11 => ['2.7.2', :optional]
  depends_on 'djvulibre' if build.with? 'djvu'
  depends_on 'freetype' if MacOS.version == :snow_leopard

  conflicts_with 'gambit-scheme', :because => 'both install `gsc` binaries'

  # http://sourceforge.net/projects/gs-fonts/
  resource 'fonts' do
    url 'https://downloads.sourceforge.net/project/gs-fonts/gs-fonts/8.11%20%28base%2035%2C%20GPL%29/ghostscript-fonts-std-8.11.tar.gz'
    sha1 '2a7198e8178b2e7dba87cb5794da515200b568f5'
  end

  # http://djvu.sourceforge.net/gsdjvu.html
  resource 'djvu' do
    url 'https://downloads.sourceforge.net/project/djvu/GSDjVu/1.5/gsdjvu-1.5.tar.gz'
    sha1 'c7d0677dae5fe644cf3d714c04b3c2c343906342'
  end

  # Fix dylib names, per installation instructions
  def patches
    DATA
  end

  def move_included_source_copies
    # If the install version of any of these doesn't match
    # the version included in ghostscript, we get errors
    # Taken from the MacPorts portfile - http://bit.ly/ghostscript-portfile
    renames = %w{freetype jbig2dec jpeg libpng tiff zlib}
    renames.each { |lib| mv lib, "#{lib}_local" }
  end

  def install
    src_dir = build.head? ? "gs" : "."

    resource('djvu').stage do
      inreplace 'gdevdjvu.c', /#include "gserror.h"/, ''
      (buildpath+'base').install 'gdevdjvu.c'
      (buildpath+'lib').install 'ps2utf8.ps'
      ENV['EXTRA_INIT_FILES'] = 'ps2utf8.ps'
      (buildpath/'base/contrib.mak').open('a') { |f| f.write(File.read('gsdjvu.mak')) }
    end if build.with? 'djvu'

    cd src_dir do
      move_included_source_copies
      args = %W[
        --prefix=#{prefix}
        --disable-cups
        --disable-compile-inits
        --disable-gtk
        --with-system-libtiff
      ]
      args << '--without-x' if build.without? 'x11'

      if build.head?
        system './autogen.sh', *args
      else
        system './configure', *args
      end

      # versioned stuff in main tree is pointless for us
      inreplace 'Makefile', '/$(GS_DOT_VERSION)', ''

      inreplace 'Makefile' do |s|
        s.change_make_var!('DEVICE_DEVS17','$(DD)djvumask.dev $(DD)djvusep.dev')
      end if build.with? 'djvu'

      # Install binaries and libraries
      system 'make', 'install'
      system 'make', 'install-so'
    end

    (share+'ghostscript/fonts').install resource('fonts')

    (man+'de').rmtree
  end
end

__END__
--- a/base/unix-dll.mak
+++ b/base/unix-dll.mak
@@ -64,12 +64,12 @@


 # MacOS X
-#GS_SOEXT=dylib
-#GS_SONAME=$(GS_SONAME_BASE).$(GS_SOEXT)
-#GS_SONAME_MAJOR=$(GS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_SOEXT)
-#GS_SONAME_MAJOR_MINOR=$(GS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_VERSION_MINOR).$(GS_SOEXT)
+GS_SOEXT=dylib
+GS_SONAME=$(GS_SONAME_BASE).$(GS_SOEXT)
+GS_SONAME_MAJOR=$(GS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_SOEXT)
+GS_SONAME_MAJOR_MINOR=$(GS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_VERSION_MINOR).$(GS_SOEXT)
 #LDFLAGS_SO=-dynamiclib -flat_namespace
-#LDFLAGS_SO_MAC=-dynamiclib -install_name $(GS_SONAME_MAJOR_MINOR)
+LDFLAGS_SO_MAC=-dynamiclib -install_name __PREFIX__/lib/$(GS_SONAME_MAJOR_MINOR)
 #LDFLAGS_SO=-dynamiclib -install_name $(FRAMEWORK_NAME)

 GS_SO=$(BINDIR)/$(GS_SONAME)

#--- a/base/stdpre.h
#+++ b/base/stdpre.h
#@@ -20,7 +20,7 @@
 ##  define stdpre_INCLUDED

 #/* Ghostscript uses transitional LFS functions. */
#-#define _LARGEFILE64_SOURCE 1
#+/* #define _LARGEFILE64_SOURCE 1 */

 ##ifndef _FILE_OFFSET_BITS
 ##define _FILE_OFFSET_BITS 64
