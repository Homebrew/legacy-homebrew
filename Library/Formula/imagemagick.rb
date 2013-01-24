require 'formula'

def ghostscript_srsly?
  build.include? 'with-ghostscript'
end

def ghostscript_fonts?
  File.directory? "#{HOMEBREW_PREFIX}/share/ghostscript/fonts"
end

class Imagemagick < Formula
  homepage 'http://www.imagemagick.org'

  # upstream's stable tarballs tend to disappear, so we provide our own mirror
  # Tarball from: http://www.imagemagick.org/download/ImageMagick.tar.gz
  # SHA-256 from: http://www.imagemagick.org/download/digest.rdf
  url 'http://downloads.sf.net/project/machomebrew/mirror/ImageMagick-6.8.0-10.tar.gz'
  sha256 'b3dfcb44300f73e73ffa8deef8bba4cf43f03d7150bf1fd0febedceac1a45c7e'

  head 'https://www.imagemagick.org/subversion/ImageMagick/trunk',
    :using => UnsafeSubversionDownloadStrategy

  option 'with-ghostscript', 'Compile against ghostscript (not recommended.)'
  option 'use-tiff', 'Compile with libtiff support.'
  option 'use-cms', 'Compile with little-cms support.'
  option 'use-jpeg2000', 'Compile with jasper support.'
  option 'use-wmf', 'Compile with libwmf support.'
  option 'use-rsvg', 'Compile with librsvg support.'
  option 'use-lqr', 'Compile with liblqr support.'
  option 'use-exr', 'Compile with openexr support.'
  option 'enable-openmp', 'Enable OpenMP (not supported on Leopard or with Clang).'
  option 'disable-opencl', 'Disable OpenCL.'
  option 'enable-hdri', 'Compile with HDRI support enabled'
  option 'without-magick-plus-plus', "Don't compile C++ interface."
  option 'with-quantum-depth-8', 'Compile with a quantum depth of 8 bit'
  option 'with-quantum-depth-16', 'Compile with a quantum depth of 16 bit'
  option 'with-quantum-depth-32', 'Compile with a quantum depth of 32 bit'
  option 'with-x', 'Compile with X11 support.'
  option 'with-fontconfig', 'Compile with fontconfig support.'
  option 'without-freetype', 'Compile without freetype support.'

  depends_on 'pkg-config' => :build

  depends_on 'jpeg' => :recommended
  depends_on :libpng
  depends_on :libtool
  depends_on :x11 if build.include? 'with-x'
  # Can't use => with symbol deps
  depends_on :fontconfig if build.include? 'with-fontconfig' or MacOS::X11.installed? # => :optional
  depends_on :freetype unless build.include? 'without-freetype' and not MacOS::X11.installed? # => :recommended

  depends_on 'ghostscript' => :optional if ghostscript_srsly?

  depends_on 'libtiff' => :optional if build.include? 'use-tiff'
  depends_on 'little-cms' => :optional if build.include? 'use-cms'
  depends_on 'jasper' => :optional if build.include? 'use-jpeg2000'
  depends_on 'libwmf' => :optional if build.include? 'use-wmf'
  depends_on 'librsvg' => :optional if build.include? 'use-rsvg'
  depends_on 'liblqr' => :optional if build.include? 'use-lqr'
  depends_on 'openexr' => :optional if build.include? 'use-exr'

  bottle do
    sha1 '543ce5bf72c3897f25b54523a5c3de355a84ff44' => :mountainlion
    sha1 '1966734b73b2cf77f47e639fe7ae48603dec15bd' => :lion
    sha1 '1068830a71fb1f990d8fcb06495693eaeb4edafc' => :snowleopard
  end

  skip_clean :la

  def install
    args = [ "--disable-osx-universal-binary",
             "--without-perl", # I couldn't make this compile
             "--prefix=#{prefix}",
             "--disable-dependency-tracking",
             "--enable-shared",
             "--disable-static",
             "--without-pango",
             "--with-included-ltdl",
             "--with-modules"]

    args << "--disable-openmp" unless build.include? 'enable-openmp'
    args << "--disable-opencl" if build.include? 'disable-opencl'
    args << "--without-gslib" unless build.include? 'with-ghostscript'
    args << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts" \
                unless ghostscript_srsly? or ghostscript_fonts?
    args << "--without-magick-plus-plus" if build.include? 'without-magick-plus-plus'
    args << "--enable-hdri=yes" if build.include? 'enable-hdri'

    if build.include? 'with-quantum-depth-32'
      quantum_depth = 32
    elsif build.include? 'with-quantum-depth-16'
      quantum_depth = 16
    elsif build.include? 'with-quantum-depth-8'
      quantum_depth = 8
    end

    args << "--with-quantum-depth=#{quantum_depth}" if quantum_depth
    args << "--with-rsvg" if build.include? 'use-rsvg'
    args << "--without-x" unless build.include? 'with-x'
    args << "--with-fontconfig=yes" if build.include? 'with-fontconfig' or MacOS::X11.installed?
    args << "--with-freetype=yes" unless build.include? 'without-freetype' and not MacOS::X11.installed?

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
    system "#{bin}/identify", \
      "/System/Library/Frameworks/SecurityInterface.framework/Versions/A/Resources/Key_Large.png"
  end
end
