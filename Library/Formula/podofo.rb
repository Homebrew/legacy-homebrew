class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "http://podofo.sourceforge.net"
  url "https://downloads.sourceforge.net/podofo/podofo-0.9.3.tar.gz"
  sha256 "ec261e31e89dce45b1a31be61e9c6bb250532e631a02d68ec5bb849ef0a222d8"
  revision 1

  bottle do
    cellar :any
    sha256 "de00466beb51138f76ef2229079bf11ee858a9eca375eb142be2b02e06a4d183" => :el_capitan
    sha256 "dfc753d91fe5301fcf250165365e7a1897bacbf1cb652256722961c10028ad6b" => :yosemite
    sha256 "02040cb02339a7842136a01a708da16b0924a0e6f24f6d4c71d80061554a14d1" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "openssl"
  depends_on "libidn" => :optional

  def install
    args = std_cmake_args

    # Build shared to simplify linking for other programs.
    args << "-DPODOFO_BUILD_SHARED:BOOL=TRUE"

    args << "-DFREETYPE_INCLUDE_DIR_FT2BUILD=#{Formula["freetype"].opt_include}/freetype2"
    args << "-DFREETYPE_INCLUDE_DIR_FTHEADER=#{Formula["freetype"].opt_include}/freetype2/config/"

    # podofo scoops out non-mandatory dependencies from system automatically.
    # Build fails against multi-lua systems, even when direct path is passed to cmake.
    # https://github.com/Homebrew/homebrew/issues/44026
    # DomT4: Reported upstream 19/12/2015 to mailing list but not published yet.
    # This seemingly unofficial hack doesn't work for libidn sadly.
    args << "-DLUA_INCLUDE_DIR=FALSE" << "-DLUA_LIBRARIES=FALSE"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    assert_match "500 x 800 pts", shell_output("#{bin}/podofopdfinfo test.pdf")
  end
end
