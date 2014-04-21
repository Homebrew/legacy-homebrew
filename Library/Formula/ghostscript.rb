require 'formula'

class Ghostscript < Formula
  homepage 'http://www.ghostscript.com/'

  stable do
    url 'http://downloads.ghostscript.com/public/ghostscript-9.14.tar.gz'
    sha1 '85001be316ebc11a6060ae7e208fe08dcbfd70ae'

    patch :DATA # Uncomment OS X-specific make vars
  end

  bottle do
    revision 1
    sha1 "308a8f34a919cf8b7aaa919b74aa3bc7606cf24f" => :mavericks
    sha1 "db1b4c91a40cedba2386ced95bd63f9bcb832efa" => :mountain_lion
    sha1 "b63f8d414e7e07ac554c5869385e7cb657c3a26a" => :lion
  end

  head do
    url 'git://git.ghostscript.com/ghostpdl.git'

    resource 'djvu' do
      url 'git://git.code.sf.net/p/djvu/gsdjvu-git'
    end

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool

    # Uncomment OS X-specific make vars
    patch do
      url "https://gist.githubusercontent.com/jacknagel/9559501/raw/9709b3234cc888d29f717838650d29e7062da917/gs.patch"
      sha1 "65c99df4f0d57368a086154d34722f5c4b9c84cc"
    end
  end

  option 'with-djvu', 'Build drivers for DjVU file format'

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'jbig2dec'
  depends_on 'little-cms2'
  depends_on 'libpng'
  depends_on :x11 => ['2.7.2', :optional]
  depends_on 'djvulibre' if build.with? 'djvu'
  depends_on 'freetype'

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

  def move_included_source_copies
    # If the install version of any of these doesn't match
    # the version included in ghostscript, we get errors
    # Taken from the MacPorts portfile - http://bit.ly/ghostscript-portfile
    renames = %w{freetype jbig2dec jpeg libpng tiff}
    renames.each { |lib| mv lib, "#{lib}_local" }
  end

  def install
    src_dir = build.head? ? "gs" : "."

    resource('djvu').stage do
      inreplace 'gdevdjvu.c', /#include "gserror.h"/, ''
      (buildpath+'base').install 'gdevdjvu.c'
      (buildpath+'lib').install 'ps2utf8.ps'
      ENV['EXTRA_INIT_FILES'] = 'ps2utf8.ps'
      (buildpath/'devices/contrib.mak').open('a') { |f| f.write(File.read('gsdjvu.mak')) }
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
diff --git a/base/unix-dll.mak b/base/unix-dll.mak
index ae2d7d8..4f4daed 100644
--- a/base/unix-dll.mak
+++ b/base/unix-dll.mak
@@ -64,12 +64,12 @@ GS_SONAME_MAJOR_MINOR=$(GS_SONAME_BASE)$(GS_SOEXT)$(SO_LIB_VERSION_SEPARATOR)$(G
 
 
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

