class Imagemagick < Formula
  homepage "http://www.imagemagick.org"
  url "http://www.imagemagick.org/download/releases/ImageMagick-6.9.1-1.tar.xz"
  mirror "https://downloads.sourceforge.net/project/imagemagick/6.9.1-sources/ImageMagick-6.9.1-1.tar.xz"
  sha256 "8f6ebeb1a1321fd7b7d3161a66461743ea5bbc352e4339c792b3bab52c379378"

  head "https://subversion.imagemagick.org/subversion/ImageMagick/trunk",
       :using => :svn

  bottle do
    sha256 "eacabf24a4e3d99feca1a3c9786f18328a5e9dee866e710ee8c505e35cfded62" => :yosemite
    sha256 "b346a7e2fe4f0886c0b2453f05fc66bc83463e30b2039ac04876b54d3031f4cd" => :mavericks
    sha256 "2373116c43b825f34d84fc6302c52b4a48375487ff460a844cadb64d2f0b1768" => :mountain_lion
  end

  deprecated_option "enable-hdri" => "with-hdri"

  option "with-fftw", "Compile with FFTW support"
  option "with-hdri", "Compile with HDRI support"
  option "with-jp2", "Compile with Jpeg2000 support"
  option "with-perl", "enable build/install of PerlMagick"
  option "with-quantum-depth-8", "Compile with a quantum depth of 8 bit"
  option "with-quantum-depth-16", "Compile with a quantum depth of 16 bit"
  option "with-quantum-depth-32", "Compile with a quantum depth of 32 bit"
  option "without-opencl", "Disable OpenCL"
  option "without-magick-plus-plus", "disable build/install of Magick++"

  depends_on "xz"
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
  depends_on "fftw" => :optional
  depends_on "pango" => :optional

  skip_clean :la

  def install
    args = %W[
      --disable-osx-universal-binary
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-shared
      --disable-static
      --with-modules
      --disable-openmp
    ]

    args << "--disable-opencl" if build.without? "opencl"
    args << "--without-gslib" if build.without? "ghostscript"
    args << "--without-perl" if build.without? "perl"
    args << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts" if build.without? "ghostscript"
    args << "--without-magick-plus-plus" if build.without? "magick-plus-plus"
    args << "--enable-hdri=yes" if build.with? "hdri"
    args << "--enable-fftw=yes" if build.with? "fftw"
    args << "--without-pango" if build.without? "pango"

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
    system "make", "install"
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
    system "#{bin}/identify", test_fixtures("test.png")
  end
end
