require 'formula'

class GhostscriptFonts < Formula
  url 'http://downloads.sourceforge.net/project/gs-fonts/gs-fonts/8.11%20%28base%2035%2C%20GPL%29/ghostscript-fonts-std-8.11.tar.gz'
  homepage 'http://sourceforge.net/projects/gs-fonts/'
  md5 '6865682b095f8c4500c54b285ff05ef6'
end

class Ghostscript < Formula
  url 'http://downloads.ghostscript.com/public/ghostscript-9.04.tar.bz2'
  head 'git://git.ghostscript.com/ghostpdl.git'
  homepage 'http://www.ghostscript.com/'
  md5 '9f6899e821ab6d78ab2c856f10fa3023'

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'libtiff'

  # The patches fix compilation against libpng 1.5, provided by Lion.
  # Patch by @CharlieRoot
  def patches
    DATA unless ARGV.build_head?
  end

  def move_included_source_copies
    # If the install version of any of these doesn't match
    # the version included in ghostscript, we get errors
    # Taken from the MacPorts portfile - http://bit.ly/ghostscript-portfile
    renames = [ "jpeg", "libpng", "zlib", "tiff" ]
    renames << "freetype" if 10.7 <= MACOS_VERSION
    renames.each do |lib|
      mv lib, "#{lib}_local"
    end
  end

  def install
    ENV.libpng
    ENV.deparallelize
    # O4 takes an ungodly amount of time
    ENV.O3
    # ghostscript configure ignores LDFLAGs apparently
    ENV['LIBS']="-L/usr/X11/lib"

    src_dir = ARGV.build_head? ? "gs" : "."

    cd src_dir do
      move_included_source_copies

      system "./autogen.sh" if ARGV.build_head?
      system "./configure", "--prefix=#{prefix}", "--disable-debug",
                            # the cups component adamantly installs to /usr so fuck it
                            "--disable-cups",
                            "--disable-compile-inits",
                            "--disable-gtk"

      # versioned stuff in main tree is pointless for us
      inreplace 'Makefile', '/$(GS_DOT_VERSION)', ''
      system "make install"
    end

    GhostscriptFonts.new.brew do
      Dir.chdir '..'
      (share+'ghostscript').install 'fonts'
    end

    (man+'de').rmtree
  end
end

__END__
diff --git a/base/Makefile.in b/base/Makefile.in
index 5b7847d..85e1a32 100644
--- a/base/Makefile.in
+++ b/base/Makefile.in
@@ -375,7 +375,7 @@ LDFLAGS=@LDFLAGS@ $(XLDFLAGS)
 # Solaris may need -lnsl -lsocket -lposix4.
 # (Libraries required by individual drivers are handled automatically.)
 
-EXTRALIBS=@LIBS@ @DYNAMIC_LIBS@ @FONTCONFIG_LIBS@
+EXTRALIBS=@LIBS@ @DYNAMIC_LIBS@ @FONTCONFIG_LIBS@ @FT_LIBS@
 
 # Define the standard libraries to search at the end of linking.
 # Most platforms require -lpthread for the POSIX threads library;

