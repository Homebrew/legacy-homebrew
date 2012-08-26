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

  if ARGV.build_head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'jbig2dec'
  depends_on 'little-cms2'
  depends_on :libpng

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
<<<<<<< HEAD
    ENV['LIBS'] = "-L#{MacOS::XQuartz.lib}"
=======
    ENV['LIBS'] = "-L#{MacOS::X11.lib}"
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879

    src_dir = ARGV.build_head? ? "gs" : "."

    cd src_dir do
      move_included_source_copies
      args = %W[
        --prefix=#{prefix}
        --disable-cups
        --disable-compile-inits
        --disable-gtk
        --with-system-libtiff
      ]

      if ARGV.build_head?
        system './autogen.sh', *args
      else
        system './configure', *args
      end
      # versioned stuff in main tree is pointless for us
      inreplace 'Makefile', '/$(GS_DOT_VERSION)', ''
      system "make install"
    end

    GhostscriptFonts.new.brew do
      (share+'ghostscript').install '../fonts'
    end

    (man+'de').rmtree
  end
end
