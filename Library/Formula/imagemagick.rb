require 'formula'

# some credit to http://github.com/maddox/magick-installer
# NOTE please be aware that the GraphicsMagick formula derives this formula

def ghostscript_srsly?
  ARGV.include? '--with-ghostscript'
end

def x11?
  # I used this file because old Xcode seems to lack it, and its that old
  # Xcode that loads of people seem to have installed still
  File.file? '/usr/X11/include/ft2build.h'
end

class Imagemagick <Formula
  @url='http://image_magick.veidrodis.com/image_magick/ImageMagick-6.5.9-8.tar.bz2'
  @md5='89892e250e81fad51b4b2a1f816987e6'
  @homepage='http://www.imagemagick.org'


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
  
  def fix_configure
    # versioned stuff in main tree is pointless for us
    inreplace 'configure', '${PACKAGE_NAME}-${PACKAGE_VERSION}', '${PACKAGE_NAME}'
  end
  
  def configure_args
    args = ["--prefix=#{prefix}", 
     "--disable-dependency-tracking",
     "--enable-shared",
     "--disable-static",
     "--with-modules",
     "--without-magick-plus-plus"]
     
     args << "--disable-openmp" if MACOS_VERSION < 10.6   # libgomp unavailable
     args << '--without-ghostscript' \
          << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts" \
             unless ghostscript_srsly?
     return args
  end

  def install
    ENV.libpng
    ENV.deparallelize
    ENV.O3 # takes forever otherwise

    fix_configure

    system "./configure", "--without-maximum-compile-warnings",
                          "--disable-osx-universal-binary",
                          "--without-perl", # I couldn't make this compile
                          *configure_args
    system "make install"

    # We already copy these into the keg root
    (share+"ImageMagick/NEWS.txt").unlink
    (share+"ImageMagick/LICENSE").unlink
    (share+"ImageMagick/ChangeLog").unlink
  end

  def caveats
    "You don't have X11 from the Xcode DMG installed. Consequently Imagemagick is less fully featured." unless x11?
  end
end
