require 'formula'

# This formula used to drive from ImageMagick, but has diverged.

def ghostscript_fonts?
  File.directory? "#{HOMEBREW_PREFIX}/share/ghostscript/fonts"
end

def ghostscript_srsly?
  ARGV.include? '--with-ghostscript'
end

def use_wmf?
  ARGV.include? '--use-wmf'
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
  depends_on 'libwmf' if use_wmf?
  depends_on 'libtiff' => :optional
  depends_on 'little-cms' => :optional
  depends_on 'jasper' => :optional
  depends_on 'ghostscript' => :recommended if ghostscript_srsly? and x11?
  depends_on 'libpng' unless x11?

  def skip_clean? path
    path.extname == '.la'
  end

  def options
    [
      ['--with-ghostscript', 'Compile against ghostscript (not recommended.)'],
      ['--with-magick-plus-plus', 'With C++ library.'],
      ['--use-wmf', 'Compile with libwmf support.'],
    ]
  end

  def install
    fails_with_llvm
    ENV.libpng
    ENV.O3

    # versioned stuff in main tree is pointless for us
    inreplace 'configure', '${PACKAGE_NAME}-${PACKAGE_VERSION}', '${PACKAGE_NAME}'

    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--enable-shared", "--disable-static"]
    args << "--without-magick-plus-plus" unless ARGV.include? '--with-magick-plus-plus'
    args << "--disable-openmp" if MACOS_VERSION < 10.6   # libgomp unavailable
    args << "--with-gslib" if ghostscript_srsly?
    args << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts" \
              unless ghostscript_fonts?

    system "./configure", *args
    system "make install"
  end

  def caveats; <<-EOS.undent
    You don't have X11 from the Xcode DMG installed. Consequently GraphicsMagick
    is less fully featured.
    EOS
  end unless x11?
end
