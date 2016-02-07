class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-2.0.4.tar.gz"
  sha256 "e3b1f5b9f8ce750f96b9bc9801ff5d6aa931d35300d67711826e397df43c5245"

  bottle do
    cellar :any
    sha256 "22c9bdbc35f215f8ddf524ff5b3d0cb2cd8295f29f96c5e9c6179b8267b692b9" => :el_capitan
    sha256 "8c1816bd05d9e16b4ba287c60089d84d6e02fe5d99cb0d005076fb99e22c58c3" => :yosemite
    sha256 "3e608f7eeaa6c76e31a26209aa1e4ad4136cab30bd49192e663cb4f2df06bff3" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <assert.h>
      #include <zimg.h>

      int main()
      {
        zimg_image_format format;
        zimg_image_format_default(&format, ZIMG_API_VERSION);
        assert(ZIMG_MATRIX_UNSPECIFIED == format.matrix_coefficients);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lzimg", "-o", "test"
    system "./test"
  end
end
