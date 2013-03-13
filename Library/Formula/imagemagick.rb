require 'formula'

class Imagemagick < Formula
  homepage 'http://www.imagemagick.org'

  # upstream's stable tarballs tend to disappear, so we provide our own mirror
  # Tarball from: http://www.imagemagick.org/download/ImageMagick.tar.gz
  # SHA-256 from: http://www.imagemagick.org/download/digest.rdf
  url 'http://downloads.sf.net/project/machomebrew/mirror/ImageMagick-6.8.0-10.tar.gz'
  sha256 'b3dfcb44300f73e73ffa8deef8bba4cf43f03d7150bf1fd0febedceac1a45c7e'

  head 'https://www.imagemagick.org/subversion/ImageMagick/trunk',
    :using => UnsafeSubversionDownloadStrategy

  option 'with-quantum-depth-8', 'Compile with a quantum depth of 8 bit'
  option 'with-quantum-depth-16', 'Compile with a quantum depth of 16 bit'
  option 'with-quantum-depth-32', 'Compile with a quantum depth of 32 bit'

  depends_on :libltdl

  depends_on 'pkg-config' => :build

  depends_on 'jpeg' => :recommended
  depends_on :libpng => :recommended
  depends_on :freetype => :recommended

  depends_on :x11 => :optional
  depends_on :fontconfig => :optional
  depends_on 'libtiff' => :optional
  depends_on 'little-cms' => :optional
  depends_on 'jasper' => :optional
  depends_on 'libwmf' => :optional
  depends_on 'librsvg' => :optional
  depends_on 'liblqr' => :optional
  depends_on 'openexr' => :optional
  depends_on 'ghostscript' => :optional

  opoo '--with-ghostscript is not recommended' if build.with? 'ghostscript'
  if build.with? 'openmp' and (MacOS.version == 10.5 or ENV.compiler == :clang)
    opoo '--with-openmp is not supported on Leopard or with Clang'
  end

  bottle do
    revision 1
    sha1 '8a1a49f25274e34d73c1c0af27424fa68006f34f' => :mountain_lion
    sha1 'b0027bd4b4e6a82d3958eee18e5aaf3bffe1f4f1' => :lion
    sha1 'b5b3ffb0c4bf9fe247b9fdeea789298c71904a12' => :snow_leopard
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
    args << "--without-gslib" unless build.with? 'ghostscript'
    args << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts" unless build.with? 'ghostscript'
    args << "--without-magick-plus-plus" if build.without? 'magick-plus-plus'
    args << "--enable-hdri=yes" if build.include? 'enable-hdri'

    if build.with? 'quantum-depth-32'
      quantum_depth = 32
    elsif build.with? 'quantum-depth-16'
      quantum_depth = 16
    elsif build.with? 'quantum-depth-8'
      quantum_depth = 8
    end

    args << "--with-quantum-depth=#{quantum_depth}" if quantum_depth
    args << "--with-rsvg" if build.with? 'rsvg'
    args << "--without-x" unless build.with? 'x11'
    args << "--with-fontconfig=yes" if build.with? 'fontconfig'
    args << "--with-freetype=yes" if build.with? 'freetype'

    # versioned stuff in main tree is pointless for us
    inreplace 'configure', '${PACKAGE_NAME}-${PACKAGE_VERSION}', '${PACKAGE_NAME}'
    system "./configure", *args
    system "make install"
  end

  test do
    system "#{bin}/identify", \
      "/System/Library/Frameworks/SecurityInterface.framework/Versions/A/Resources/Key_Large.png"
  end
end
