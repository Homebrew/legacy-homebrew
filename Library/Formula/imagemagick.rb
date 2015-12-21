class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "http://www.imagemagick.org"
  # Please always keep the Homebrew mirror as the primary URL as the
  # ImageMagick site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://dl.bintray.com/homebrew/mirror/ImageMagick-6.9.2-10.tar.xz"
  mirror "http://www.imagemagick.org/download/releases/ImageMagick-6.9.2-10.tar.xz"
  sha256 "da2f6fba43d69f20ddb11783f13f77782b0b57783dde9cda39c9e5e733c2013c"

  head "http://git.imagemagick.org/repos/ImageMagick.git"

  bottle do
    sha256 "9e917276d3c52d6664074e2a9d9e82aeacc02412c4939d0bb526813ba5a6f4bf" => :el_capitan
    sha256 "1c7497ac418aa3c5fccc64c71d0d90c3844d300cc2bc0d5d5d3e18cb74b1cc96" => :yosemite
    sha256 "80dc190571c6e01783887f7a55537bdea7adb298885e9896e2f72516b96886f1" => :mavericks
  end

  deprecated_option "enable-hdri" => "with-hdri"

  option "with-fftw", "Compile with FFTW support"
  option "with-hdri", "Compile with HDRI support"
  option "with-jp2", "Compile with Jpeg2000 support"
  option "with-openmp", "Compile with OpenMP support"
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
  depends_on "libtiff" => :recommended
  depends_on "freetype" => :recommended

  depends_on :x11 => :optional
  depends_on "fontconfig" => :optional
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

  needs :openmp if build.with? "openmp"

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
    ]

    if build.with? "openmp"
      args << "--enable-openmp"
    else
      args << "--disable-openmp"
    end
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
