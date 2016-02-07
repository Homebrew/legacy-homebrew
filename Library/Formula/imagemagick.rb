class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "http://www.imagemagick.org"
  # Please always keep the Homebrew mirror as the primary URL as the
  # ImageMagick site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://dl.bintray.com/homebrew/mirror/ImageMagick-6.9.3-0.tar.xz"
  mirror "http://www.imagemagick.org/download/releases/ImageMagick-6.9.3-0.tar.xz"
  sha256 "2ba0656eb03d72d8a44e741ead524e8c34097418c0bb5487a5c4f4fe5eca9656"
  revision 1

  head "http://git.imagemagick.org/repos/ImageMagick.git"

  bottle do
    sha256 "eae8dc8e1385bedba0469574b0cc59118f66786b9909469dbdd24efbabb5547f" => :el_capitan
    sha256 "7e18754dc96ef83e900c72e3965bb70a1602c0a168db167e0fcc64447df72ee6" => :yosemite
    sha256 "5f57d9738f07fdb737c3744aec397ec0d12d84a2e8975c0bb51b8c2d11ceca91" => :mavericks
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
    ENV.delete "PERL_MM_OPT"

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
    args << "--with-perl" << "--with-perl-options='PREFIX=#{prefix}'" if build.with? "perl"
    args << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts" if build.without? "ghostscript"
    args << "--without-magick-plus-plus" if build.without? "magick-plus-plus"
    args << "--enable-hdri=yes" if build.with? "hdri"
    args << "--enable-fftw=yes" if build.with? "fftw"
    args << "--without-pango" if build.without? "pango"

    if build.with? "quantum-depth-32"
      quantum_depth = 32
    elsif build.with?("quantum-depth-16") || build.with?("perl")
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
      For full Perl support you may need to adjust your PERL5LIB variable:
        export PERL5LIB="#{HOMEBREW_PREFIX}/lib/perl5/site_perl":$PERL5LIB
    EOS
    s if build.with? "perl"
  end

  test do
    system "#{bin}/identify", test_fixtures("test.png")
  end
end
