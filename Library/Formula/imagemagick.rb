require 'formula'

# some credit to http://github.com/maddox/magick-installer
# NOTE please be aware that the GraphicsMagick formula derives this formula

def ghostscript_srsly?
  ARGV.include? '--with-ghostscript'
end

class Imagemagick <Formula
  @url='http://image_magick.veidrodis.com/image_magick/ImageMagick-6.5.6-5.tar.gz'
  @md5='668919a5a7912fb6778975bc55893004'
  @homepage='http://www.imagemagick.org'

  depends_on 'jpeg'
  depends_on 'libwmf' => :optional if x11?
  depends_on 'libtiff' => :optional
  depends_on 'little-cms' => :optional
  depends_on 'jasper' => :optional
  depends_on 'ghostscript' => :recommended if ghostscript_srsly? and x11?

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
    (share+'ImageMagick'+'NEWS.txt').unlink
    (share+'ImageMagick'+'LICENSE').unlink
    (share+'ImageMagick'+'ChangeLog').unlink
  end

  def caveats
    "You don't have X11 from the Xcode DMG installed. Consequently Imagemagick is less fully featured." unless x11?
  end

  def self.x11?
    File.file? '/usr/X11/include/ft2build.h'
  end
end
