require 'formula'

class GhostscriptFonts < Formula
  homepage 'http://code.google.com/p/ghostscript/'
  url 'http://ghostscript.googlecode.com/files/ghostscript-fonts-std-8.11.tar.gz'
  sha1 '2a7198e8178b2e7dba87cb5794da515200b568f5'
end

class Ghostscript < Formula
  homepage 'http://www.ghostscript.com/'
  url 'http://downloads.ghostscript.com/public/ghostscript-9.05.tar.gz'
  md5 'f7c6f0431ca8d44ee132a55d583212c1'

  head 'git://git.ghostscript.com/ghostpdl.git'

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'libtiff'

  if ARGV.build_head? and MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def move_included_source_copies
    # If the install version of any of these doesn't match
    # the version included in ghostscript, we get errors
    # Taken from the MacPorts portfile - http://bit.ly/ghostscript-portfile
    renames = ["jpeg", "libpng", "tiff", "zlib"]
    renames << "freetype" if 10.7 <= MACOS_VERSION
    renames.each do |lib|
      mv lib, "#{lib}_local"
    end
  end

  def install
    ENV.libpng
    ENV.deparallelize
    # ghostscript configure ignores LDFLAGs apparently
    ENV['LIBS'] = "-L/usr/X11/lib"

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
      (share+'ghostscript').install '../fonts'
    end

    (man+'de').rmtree
  end
end
