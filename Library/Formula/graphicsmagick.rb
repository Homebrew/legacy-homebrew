require 'formula'

# This formula used to drive from ImageMagick, but has diverged.

def ghostscript_fonts?
  File.directory? "#{HOMEBREW_PREFIX}/share/ghostscript/fonts"
end

def ghostscript_srsly?
  ARGV.include? '--with-ghostscript'
end

def x11?
  # I used this file because old Xcode seems to lack it, and its that old
  # Xcode that loads of people seem to have installed still
  File.file? '/usr/X11/include/ft2build.h'
end

class Graphicsmagick <Formula
  url 'http://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.12/GraphicsMagick-1.3.12.tar.bz2'
  homepage 'http://www.graphicsmagick.org/'
  md5 '55182f371f82d5f9367bce04e59bbf25'

  depends_on 'jpeg'
  depends_on 'libwmf' => :optional if x11?
  depends_on 'libtiff' => :optional
  depends_on 'little-cms' => :optional
  depends_on 'jasper' => :optional
  depends_on 'ghostscript' => :recommended if ghostscript_srsly? and x11?
  depends_on 'libpng' unless x11?

  def skip_clean? path
    path.extname == '.la'
  end

  def install
    fails_with_llvm
    ENV.libpng
    ENV.O3

    # versioned stuff in main tree is pointless for us
    inreplace 'configure', '${PACKAGE_NAME}-${PACKAGE_VERSION}', '${PACKAGE_NAME}'

    args = [ "--prefix=#{prefix}",
             "--disable-dependency-tracking",
             "--enable-shared",
             "--disable-static",
             "--with-modules",
             "--without-magick-plus-plus" ]

     args << "--disable-openmp" if MACOS_VERSION < 10.6   # libgomp unavailable
     args << "--with-gslib" if ghostscript_srsly?
     args << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts" \
              unless ghostscript_fonts?

    system "./configure", *args
    system "make install"
  end

  def caveats
    "You don't have X11 from the Xcode DMG installed. Consequently GraphicsMagick is less fully featured." unless x11?
  end
end
