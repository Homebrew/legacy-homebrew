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

def use_rsvg?
  ARGV.include? '--use-rsvg'
end

def use_lqr?
  ARGV.include? '--use-lqr'
end

def disable_openmp?
  ARGV.include? '--disable-openmp'
end

def enable_hdri?
  ARGV.include? '--enable-hdri'
end

def magick_plus_plus?
  ARGV.include? '--with-magick-plus-plus'
end

def use_exr?
  ARGV.include? '--use-exr'
end

def quantum_depth_8?
  ARGV.include? '--with-quantum-depth-8'
end

def quantum_depth_16?
  ARGV.include? '--with-quantum-depth-16'
end

def quantum_depth_32?
  ARGV.include? '--with-quantum-depth-32'
end


class Imagemagick < Formula
  homepage 'http://www.imagemagick.org'

  # upstream's stable tarballs tend to disappear, so we provide our own mirror
  url 'http://www.imagemagick.org/download/ImageMagick-6.7.8-8.tar.bz2'
  sha256 '817b54ad9eaaa62112b901ad4359386f07fc26634bc1920869f2742f9ec6ac6e'

  head 'https://www.imagemagick.org/subversion/ImageMagick/trunk',
    :using => UnsafeSubversionDownloadStrategy

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'

  depends_on :x11

  depends_on 'ghostscript' => :recommended if ghostscript_srsly?

  depends_on 'libtiff' => :optional
  depends_on 'little-cms' => :optional
  depends_on 'jasper' => :optional

  depends_on 'libwmf' if use_wmf?
  depends_on 'librsvg' if use_rsvg?
  depends_on 'liblqr' if use_lqr?
  depends_on 'openexr' if use_exr?


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
      ['--use-wmf', 'Compile with libwmf support.'],
      ['--use-rsvg', 'Compile with librsvg support.'],
      ['--use-lqr', 'Compile with liblqr support.'],
      ['--use-exr', 'Compile with openexr support.'],
      ['--disable-openmp', 'Disable OpenMP.'],
      ['--enable-hdri', 'Compile with HDRI support enabled'],
      ['--with-magick-plus-plus', 'Compile with C++ interface.'],
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

    args << "--disable-openmp" if MacOS.leopard? or disable_openmp?
    args << "--without-gslib" unless ghostscript_srsly?
    args << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts" \
                unless ghostscript_srsly? or ghostscript_fonts?
    args << "--without-magick-plus-plus" unless magick_plus_plus?
    args << "--enable-hdri=yes" if enable_hdri?

    if quantum_depth_32?
      quantum_depth = 32
    elsif quantum_depth_16?
      quantum_depth = 16
    elsif quantum_depth_8?
      quantum_depth = 8
    end

    args << "--with-quantum-depth=#{quantum_depth}" if quantum_depth
    args << "--with-rsvg" if use_rsvg?

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
