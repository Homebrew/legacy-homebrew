class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "http://podofo.sourceforge.net"
  url "https://downloads.sourceforge.net/podofo/podofo-0.9.3.tar.gz"
  sha256 "ec261e31e89dce45b1a31be61e9c6bb250532e631a02d68ec5bb849ef0a222d8"

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "jpeg"
  depends_on "libtiff"

  def install
    mkdir "build" do
      # Build shared to simplify linking for other programs.
      system "cmake", "..",
                      "-DPODOFO_BUILD_SHARED:BOOL=TRUE",
                      "-DFREETYPE_INCLUDE_DIR_FT2BUILD=#{Formula["freetype"].include}/freetype2",
                      "-DFREETYPE_INCLUDE_DIR_FTHEADER=#{Formula["freetype"].include}/freetype2/config/",
                      *std_cmake_args
      system "make", "install"
    end
  end
end
