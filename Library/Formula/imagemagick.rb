require "formula"

class Imagemagick < Formula
  homepage "http://www.imagemagick.org"

  # upstream's stable tarballs tend to disappear, so we provide our own mirror
  # Tarball and checksum from: http://www.imagemagick.org/download
  url "https://downloads.sf.net/project/machomebrew/mirror/ImageMagick-6.8.9-5.tar.xz"
  mirror "http://www.imagemagick.org/download/ImageMagick-6.8.9-5.tar.xz"
  sha256 "ea66e0824e6c208c3318c0d02ca12376416b29a634e099a90c2c840edd7de0e1"

  head "https://www.imagemagick.org/subversion/ImageMagick/trunk",
    :using => UnsafeSubversionDownloadStrategy

  bottle do
    sha1 "e3588e692e7cedd4f2b8301faded51c4424c0aa1" => :mavericks
    sha1 "aa122e82464e28395ec4db66eb9d3577b7d3443f" => :mountain_lion
    sha1 "010f16e2c791b8b9f78a9fe67c5e636e17627f10" => :lion
  end

  option "with-quantum-depth-8", "Compile with a quantum depth of 8 bit"
  option "with-quantum-depth-16", "Compile with a quantum depth of 16 bit"
  option "with-quantum-depth-32", "Compile with a quantum depth of 32 bit"
  option "with-perl", "enable build/install of PerlMagick"
  option "without-magick-plus-plus", "disable build/install of Magick++"
  option "with-jp2", "Compile with Jpeg2000 support"
  option "enable-hdri", "Compile with HDRI support"

  depends_on "libtool" => :run

  depends_on "pkg-config" => :build

  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "freetype" => :recommended

  depends_on :x11 => :optional
  depends_on "fontconfig" => :optional
  depends_on "libtiff" => :optional
  depends_on "little-cms" => :optional
  depends_on "little-cms2" => :optional
  depends_on "libwmf" => :optional
  depends_on "librsvg" => :optional
  depends_on "liblqr" => :optional
  depends_on "openexr" => :optional
  depends_on "ghostscript" => :optional
  depends_on "webp" => :optional
  depends_on "homebrew/versions/openjpeg21" if build.with? "jp2"

  opoo "--with-ghostscript is not recommended" if build.with? "ghostscript"

  def pour_bottle?
    # If libtool is keg-only it currently breaks the bottle.
    # This is a temporary workaround until we have a better fix.
    not Formula["libtool"].keg_only?
  end

  skip_clean :la

  def install
    args = [ "--disable-osx-universal-binary",
             "--prefix=#{prefix}",
             "--disable-dependency-tracking",
             "--enable-shared",
             "--disable-static",
             "--without-pango",
             "--with-modules",
             "--disable-openmp"]

    args << "--disable-opencl" if build.include? "disable-opencl"
    args << "--without-gslib" if build.without? "ghostscript"
    args << "--without-perl" if build.without? "perl"
    args << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts" if build.without? "ghostscript"
    args << "--without-magick-plus-plus" if build.without? "magick-plus-plus"
    args << "--enable-hdri=yes" if build.include? "enable-hdri"

    if build.with? "quantum-depth-32"
      quantum_depth = 32
    elsif build.with? "quantum-depth-16"
      quantum_depth = 16
    elsif build.with? "quantum-depth-8"
      quantum_depth = 8
    end

    if build.with? "jp2"
      args << "--with-openjp2"
    else
      args << "--without-openjp2"
    end

    args << "--with-quantum-depth=#{quantum_depth}" if quantum_depth
    args << "--with-rsvg" if build.with? "librsvg"
    args << "--without-x" if build.without? "x11"
    args << "--with-fontconfig=yes" if build.with? "fontconfig"
    args << "--with-freetype=yes" if build.with? "freetype"
    args << "--with-webp=yes" if build.with? "webp"

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_VERSION}", "${PACKAGE_NAME}"
    system "./configure", *args
    system "make install"
  end

  def caveats
    s = <<-EOS.undent
      For full Perl support you must install the Image::Magick module from the CPAN.
        https://metacpan.org/module/Image::Magick

      The version of the Perl module and ImageMagick itself need to be kept in sync.
      If you upgrade one, you must upgrade the other.

      For this version of ImageMagick you should install
      version #{version} of the Image::Magick Perl module.
    EOS
    s if build.with? "perl"
  end

  test do
    test_png = HOMEBREW_LIBRARY/"Homebrew/test/fixtures/test.png"
    system "#{bin}/identify", test_png
  end
end
