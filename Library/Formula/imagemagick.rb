# some credit to https://github.com/maddox/magick-installer
require 'formula'

def ghostscript_srsly?
  ARGV.include? '--with-ghostscript'
end

def ghostscript_fonts?
  File.directory? "#{HOMEBREW_PREFIX}/share/ghostscript/fonts"
end

def use_wmf?
  ARGV.include? '--use-wmf'
end

def use_lqr?
  ARGV.include? '--use-lqr'
end

def disable_openmp?
  ARGV.include? '--disable-openmp'
end

def magick_plus_plus?
    ARGV.include? '--with-magick-plus-plus'
end

class Imagemagick < Formula
  # Using an unofficial Git mirror to work around:
  # * Stable tarballs disappearing
  # * Bad https cert on official SVN repo
  version '6.7.1-1'
  url "https://github.com/trevor/ImageMagick/tarball/#{version}"
  md5 '9c71dfbddc42b78a0d8db8acdb534d37'
  homepage 'http://www.imagemagick.org'
  head 'https://github.com/trevor/ImageMagick.git'

  bottle "http://downloads.sf.net/project/machomebrew/Bottles/imagemagick-#{version}-bottle.tar.gz"
  bottle_sha1 'bff8db4da4bd255b01b483e0629e093ee76a9eb9'

  depends_on 'jpeg'

  depends_on 'ghostscript' => :recommended if ghostscript_srsly?

  depends_on 'libtiff' => :optional
  depends_on 'little-cms' => :optional
  depends_on 'jasper' => :optional

  depends_on 'libwmf' if use_wmf?
  depends_on 'liblqr' if use_lqr?

  def skip_clean? path
    path.extname == '.la'
  end

  def options
    [
      ['--with-ghostscript', 'Compile against ghostscript (not recommended.)'],
      ['--use-wmf', 'Compile with libwmf support.'],
      ['--use-lqr', 'Compile with liblqr support.'],
      ['--disable-openmp', 'Disable OpenMP.'],
      ['--with-magick-plus-plus', 'Compile with C++ interface.']
    ]
  end

  def install
    ENV.x11 # Add to PATH for freetype-config on Snow Leopard
    ENV.O3 # takes forever otherwise

    args = [ "--disable-osx-universal-binary",
             "--without-perl", # I couldn't make this compile
             "--prefix=#{prefix}",
             "--disable-dependency-tracking",
             "--enable-shared",
             "--disable-static",
             "--with-modules"]

    args << "--disable-openmp" if MacOS.leopard? or disable_openmp?
    args << "--without-gslib" unless ghostscript_srsly?
    args << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts" \
                unless ghostscript_srsly? or ghostscript_fonts?
    args << "--without-magick-plus-plus" unless magick_plus_plus?

    # versioned stuff in main tree is pointless for us
    inreplace 'configure', '${PACKAGE_NAME}-${PACKAGE_VERSION}', '${PACKAGE_NAME}'
    system "./configure", *args
    system "make install"
  end

  def caveats
    unless ghostscript_fonts? or ghostscript_srsly?
      <<-EOS.undent
      Some tools will complain unless the ghostscript fonts are installed to:
        #{HOMEBREW_PREFIX}/share/ghostscript/fonts
      EOS
    end
  end

  def test
    system "#{bin}/identify", "/Library/Application Support/Apple/iChat Icons/Flags/Argentina.gif"
  end
end
