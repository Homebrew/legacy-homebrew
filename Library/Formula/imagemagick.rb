# some credit to https://github.com/maddox/magick-installer
require 'formula'

def ghostscript_srsly?
  ARGV.include? '--with-ghostscript'
end

def ghostscript_fonts?
  File.directory? "#{HOMEBREW_PREFIX}/share/ghostscript/fonts"
end

class Imagemagick < Formula
  homepage 'http://www.imagemagick.org'

  # upstream's stable tarballs tend to disappear, so we provide our own mirror
  url 'http://downloads.sf.net/project/machomebrew/mirror/ImageMagick-6.7.7-6.tar.bz2'
  sha256 'fb32cdeef812bc2c3bb9e9f48f3cfc75c1e2640f784ef2670a0dbf948e538677'

  head 'https://www.imagemagick.org/subversion/ImageMagick/trunk',
    :using => UnsafeSubversionDownloadStrategy

  depends_on 'pkg-config' => :build

  depends_on 'jpeg'
  depends_on :libpng

  depends_on 'ghostscript' => :recommended if ghostscript_srsly?

  depends_on 'libtiff' if ARGV.include? '--use-tiff'
  depends_on 'little-cms' if ARGV.include? '--use-cms'
  depends_on 'jasper' if ARGV.include? '--use-jpeg2000'
  depends_on 'libwmf' if ARGV.include? '--use-wmf'
  depends_on 'librsvg' if ARGV.include? '--use-rsvg'
  depends_on 'liblqr' if ARGV.include? '--use-lqr'
  depends_on 'openexr' if ARGV.include? '--use-exr'

  bottle do
    version 1
    sha1 'fde8ed2686740ed83efd0626dd20170d9d3096b7' => :mountainlion
    sha1 'e2c4d5b9e5f37e5f20dec36f3f3cbfc65821e164' => :lion
    sha1 '019400feda06e4f277187702a4baeacdfdbf4851' => :snowleopard
  end

  def skip_clean? path
    path.extname == '.la'
  end

  def patches
    # Fixes xml2-config that can be missing --prefix.  See issue #11789
    # Remove if the final Mt. Lion xml2-config supports --prefix.
    # Not reporting this upstream until the final Mt. Lion is released.
    DATA
  end

  def options
    [
      ['--with-ghostscript', 'Compile against ghostscript (not recommended.)'],
      ['--use-tiff', 'Compile with libtiff support.'],
      ['--use-cms', 'Compile with little-cms support.'],
      ['--use-jpeg2000', 'Compile with jasper support.'],
      ['--use-wmf', 'Compile with libwmf support.'],
      ['--use-rsvg', 'Compile with librsvg support.'],
      ['--use-lqr', 'Compile with liblqr support.'],
      ['--use-exr', 'Compile with openexr support.'],
      ['--disable-openmp', 'Disable OpenMP.'],
      ['--enable-hdri', 'Compile with HDRI support enabled'],
      ['--without-magick-plus-plus', "Don't compile C++ interface."],
      ['--with-quantum-depth-8', 'Compile with a quantum depth of 8 bit'],
      ['--with-quantum-depth-16', 'Compile with a quantum depth of 16 bit'],
      ['--with-quantum-depth-32', 'Compile with a quantum depth of 32 bit'],
    ]
  end

  def install
    args = [ "--disable-osx-universal-binary",
             "--without-perl", # I couldn't make this compile
             "--prefix=#{prefix}",
             "--disable-dependency-tracking",
             "--enable-shared",
             "--disable-static",
             "--with-modules"]

    args << "--disable-openmp" if MacOS.leopard? or ARGV.include? '--disable-openmp'
    args << "--without-gslib" unless ARGV.include? '--with-ghostscript'
    args << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts" \
                unless ghostscript_srsly? or ghostscript_fonts?
    args << "--without-magick-plus-plus" if ARGV.include? '--without-magick-plus-plus'
    args << "--enable-hdri=yes" if ARGV.include? '--enable-hdri'

    if ARGV.include? '--with-quantum-depth-32'
      quantum_depth = 32
    elsif ARGV.include? '--with-quantum-depth-16'
      quantum_depth = 16
    elsif ARGV.include? '--with-quantum-depth-8'
      quantum_depth = 8
    end

    args << "--with-quantum-depth=#{quantum_depth}" if quantum_depth
    args << "--with-rsvg" if ARGV.include? '--use-rsvg'

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
    system "#{bin}/identify", "/Library/Application Support/Apple/iChat Icons/Flags/Argentina.*"
  end
end

__END__
--- a/configure	2012-02-25 09:03:23.000000000 -0800
+++ b/configure	2012-04-26 03:32:15.000000000 -0700
@@ -31924,7 +31924,7 @@
         # Debian installs libxml headers under /usr/include/libxml2/libxml with
         # the shared library installed under /usr/lib, whereas the package
         # installs itself under $prefix/libxml and $prefix/lib.
-        xml2_prefix=`xml2-config --prefix`
+        xml2_prefix=/usr
         if test -d "${xml2_prefix}/include/libxml2"; then
             CPPFLAGS="$CPPFLAGS -I${xml2_prefix}/include/libxml2"
         fi
