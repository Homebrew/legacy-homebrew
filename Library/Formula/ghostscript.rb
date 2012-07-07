require 'formula'

class GhostscriptFonts < Formula
  homepage 'http://sourceforge.net/projects/gs-fonts/'
  url 'http://downloads.sourceforge.net/project/gs-fonts/gs-fonts/8.11%20%28base%2035%2C%20GPL%29/ghostscript-fonts-std-8.11.tar.gz'
  md5 '6865682b095f8c4500c54b285ff05ef6'
end

class Ghostscript < Formula
  homepage 'http://www.ghostscript.com/'
  url 'http://downloads.ghostscript.com/public/ghostscript-9.05.tar.gz'
  md5 'f7c6f0431ca8d44ee132a55d583212c1'

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
    ENV['LIBS'] = "-L#{MacOS.x11_prefix}/lib"

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
