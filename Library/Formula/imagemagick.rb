# some credit to http://github.com/maddox/magick-installer
require 'formula'

class UnsafeSvn <SubversionDownloadStrategy
  def _fetch_command svncommand, url, target
    [svn, '--non-interactive', '--trust-server-cert', svncommand, '--force', url, target]
  end
end

def ghostscript_srsly?
  ARGV.include? '--with-ghostscript'
end

def ghostscript_fonts?
  File.directory? "#{HOMEBREW_PREFIX}/share/ghostscript/fonts"
end

def use_wmf?
  ARGV.include? '--use-wmf'
end

def disable_openmp?
  ARGV.include? '--disable-openmp'
end

def x11?
  # I used this file because old Xcode seems to lack it, and its that old
  # Xcode that loads of people seem to have installed still
  File.file? '/usr/X11/include/ft2build.h'
end

class Imagemagick <Formula
  url 'https://www.imagemagick.org/subversion/ImageMagick/trunk',
        :using => UnsafeSvn, :revision => '2715'
  version '6.6.4-5'
  homepage 'http://www.imagemagick.org'

  head 'https://www.imagemagick.org/subversion/ImageMagick/trunk',
        :using => UnsafeSvn

  depends_on 'jpeg'
  depends_on 'libpng' unless x11?

  depends_on 'ghostscript' => :recommended if ghostscript_srsly? and x11?

  depends_on 'libtiff' => :optional
  depends_on 'little-cms' => :optional
  depends_on 'jasper' => :optional

  depends_on 'libwmf' if use_wmf?

  def skip_clean? path
    path.extname == '.la'
  end

  def options
    [
      ['--with-ghostscript', 'Compile against ghostscript (not recommended.)'],
      ['--use-wmf', 'Compile with libwmf support.'],
      ['--disable-openmp', 'Disable OpenMP.']
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
             "--with-modules",
             "--without-magick-plus-plus" ]

    args << "--disable-openmp" if MACOS_VERSION < 10.6 or disable_openmp?
    args << "--without-gslib" unless ghostscript_srsly?
    args << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts" \
                unless ghostscript_srsly? or ghostscript_fonts?

    # versioned stuff in main tree is pointless for us
    inreplace 'configure', '${PACKAGE_NAME}-${PACKAGE_VERSION}', '${PACKAGE_NAME}'
    system "./configure", *args
    system "make install"

    # We already copy these into the keg root
    %w[NEWS.txt LICENSE ChangeLog].each {|f| (share+"ImageMagick/#{f}").unlink}
  end

  def caveats
    s = <<-EOS.undent
    Because ImageMagick likes to remove tarballs, we're downloading their
    stable release from their SVN repo instead. But they only serve the
    repo over HTTPS, and have an untrusted certificate, so we auto-accept
    this certificate for you.

    If this bothers you, open a ticket with ImageMagick to fix their cert.

    EOS
    unless x11?
      s += <<-EOS.undent
      You don't have X11 from the Xcode DMG installed. Consequently Imagemagick is less fully featured.

      EOS
    end
    unless ghostscript_fonts? or ghostscript_srsly?
      s += <<-EOS.undent
      Some tools will complain if the ghostscript fonts are not installed in:
        #{HOMEBREW_PREFIX}/share/ghostscript/fonts
      EOS
    end
    return s
  end

  def test
    system "identify", "/Library/Application Support/Apple/iChat Icons/Flags/Argentina.gif"
  end
end
