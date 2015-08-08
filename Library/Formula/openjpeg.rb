class Openjpeg < Formula
  desc "Library for JPEG-2000 image manipulation"
  homepage "http://www.openjpeg.org"
  url "https://mirrors.kernel.org/debian/pool/main/o/openjpeg/openjpeg_1.5.2.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/o/openjpeg/openjpeg_1.5.2.orig.tar.gz"
  sha256 "aef498a293b4e75fa1ca8e367c3f32ed08e028d3557b069bf8584d0c1346026d"
  revision 1

  head "https://github.com/uclouvain/openjpeg.git", :branch => "openjpeg-1.5"

  bottle do
    cellar :any
    sha256 "48a46a59c9e2ce3bd5f0658b4228151cd865ebaff551ae9885646ee35c20dd89" => :yosemite
    sha256 "63eb21603315fe49f0ed32226e08ab53c9fc7b232869d05959dc8240d51a7c2b" => :mavericks
    sha256 "1b3651ee19bd39d9a9877a3ff95736a78a419a437a6629f3ee2f85fc98e8872c" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "little-cms2"
  depends_on "libtiff"
  depends_on "libpng"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    # https://github.com/uclouvain/openjpeg/issues/562
    (lib/"pkgconfig").install_symlink lib/"pkgconfig/libopenjpeg1.pc" => "libopenjpeg.pc"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <openjpeg.h>

      int main () {
        opj_image_cmptparm_t cmptparm;
        const OPJ_COLOR_SPACE color_space = CLRSPC_GRAY;

        opj_image_t *image;
        image = opj_image_create(1, &cmptparm, color_space);

        opj_image_destroy(image);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/openjpeg-1.5", "-L#{lib}", "-lopenjpeg",
           testpath/"test.c", "-o", "test"
    system "./test"
  end
end
