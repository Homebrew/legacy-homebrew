require 'formula'

class Imagemagick < Formula
  homepage 'http://www.imagemagick.org'

  # upstream's stable tarballs tend to disappear, so we provide our own mirror
  # Tarball from: http://www.imagemagick.org/download/ImageMagick.tar.gz
  # SHA-256 from: http://www.imagemagick.org/download/digest.rdf
  url 'http://downloads.sf.net/project/machomebrew/mirror/ImageMagick-6.8.6-3.tar.bz2'
  sha256 '63b9ff1dc7cf8e7776e95c8e834c819eff5b09592728b5cdd810539e7c69e0cd'

  head 'https://www.imagemagick.org/subversion/ImageMagick/trunk',
    :using => UnsafeSubversionDownloadStrategy

  bottle do
    sha1 'f4307ebd1fe094dbd14e4e19c717baa83bdd9631' => :snow_leopard
    sha1 '45d35923b0439617adb86630bdd4985a6cf03984' => :lion
    sha1 'a0eb40e1fbf29651949c9baa530c34e7bef769f4' => :mountain_lion
  end

  option 'with-quantum-depth-8', 'Compile with a quantum depth of 8 bit'
  option 'with-quantum-depth-16', 'Compile with a quantum depth of 16 bit'
  option 'with-quantum-depth-32', 'Compile with a quantum depth of 32 bit'
  option 'without-magick-plus-plus', 'disable build/install of Magick++'

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
  depends_on 'webp' => :optional

  opoo '--with-ghostscript is not recommended' if build.with? 'ghostscript'
  if build.with? 'openmp' and (MacOS.version == 10.5 or ENV.compiler == :clang)
    opoo '--with-openmp is not supported on Leopard or with Clang'
  end

  def pour_bottle?
    # If libtool is keg-only it currently breaks the bottle.
    # This is a temporary workaround until we have a better fix.
    not Formula.factory('libtool').keg_only?
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
    args << "--with-rsvg" if build.with? 'librsvg'
    args << "--without-x" unless build.with? 'x11'
    args << "--with-fontconfig=yes" if build.with? 'fontconfig'
    args << "--with-freetype=yes" if build.with? 'freetype'
    args << "--with-webp=yes" if build.include? 'webp'

    # versioned stuff in main tree is pointless for us
    inreplace 'configure', '${PACKAGE_NAME}-${PACKAGE_VERSION}', '${PACKAGE_NAME}'
    system "./configure", *args
    system "make install"
  end

  test do
    system "#{bin}/identify", "/usr/share/doc/cups/images/smiley.jpg"
  end
end
