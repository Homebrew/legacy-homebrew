require 'formula'

class GhostscriptFonts < Formula
  homepage 'http://sourceforge.net/projects/gs-fonts/'
  url 'http://downloads.sourceforge.net/project/gs-fonts/gs-fonts/8.11%20%28base%2035%2C%20GPL%29/ghostscript-fonts-std-8.11.tar.gz'
  sha1 '2a7198e8178b2e7dba87cb5794da515200b568f5'
end

class Ghostscript < Formula
  homepage 'http://www.ghostscript.com/'
  url 'http://downloads.ghostscript.com/public/ghostscript-9.06.tar.gz'
  sha1 'a3de8ccb877ee9b7437a598196eb6afa11bf31dc'

  head 'git://git.ghostscript.com/ghostpdl.git'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'jbig2dec'
  depends_on 'little-cms2'
  depends_on :libpng

  # Fix dylib names, per installation instructions
  def patches
    DATA
  end

  def move_included_source_copies
    # If the install version of any of these doesn't match
    # the version included in ghostscript, we get errors
    # Taken from the MacPorts portfile - http://bit.ly/ghostscript-portfile
    renames = %w(jpeg libpng tiff zlib lcms2 jbig2dec)
    renames << "freetype" if 10.7 <= MACOS_VERSION
    renames.each do |lib|
      mv lib, "#{lib}_local"
    end
  end

  def install
    ENV.deparallelize
    # ghostscript configure ignores LDFLAGs apparently
    ENV['LIBS'] = "-L#{MacOS::X11.lib}"

    src_dir = build.head? ? "gs" : "."

    cd src_dir do
      move_included_source_copies
      args = %W[
        --prefix=#{prefix}
        --disable-cups
        --disable-compile-inits
        --disable-gtk
        --with-system-libtiff
      ]

      if build.head?
        system './autogen.sh', *args
      else
        system './configure', *args
      end

      # versioned stuff in main tree is pointless for us
      inreplace 'Makefile', '/$(GS_DOT_VERSION)', ''

      # Install binaries and libraries
      system "make install"
      system "make install-so"
    end

    GhostscriptFonts.new.brew do
      (share+'ghostscript').install '../fonts'
    end

    (man+'de').rmtree
  end
end

__END__
--- a/base/unix-dll.mak
+++ b/base/unix-dll.mak
@@ -59,12 +59,12 @@
 
 
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
-LDFLAGS_SO_MAC=-dynamiclib -install_name $(GS_SONAME_MAJOR_MINOR)
+LDFLAGS_SO_MAC=-dynamiclib -install_name __PREFIX__/lib/$(GS_SONAME_MAJOR_MINOR)
 #LDFLAGS_SO=-dynamiclib -install_name $(FRAMEWORK_NAME)
 
 GS_SO=$(BINDIR)/$(GS_SONAME)
