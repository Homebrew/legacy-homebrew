class Scale2x < Formula
  desc "Real-time graphics effect"
  homepage "http://scale2x.sourceforge.net"
  url "https://downloads.sourceforge.net/project/scale2x/scale2x/2.4/scale2x-2.4.tar.gz"
  sha256 "83599b1627988c941ee9c7965b6f26a9fd2608cd1e0073f7262a858d0f4f7078"
  revision 1

  depends_on "libpng"

  def install
    # This function was renamed in current versions of libpng.
    inreplace "file.c", "png_set_gray_1_2_4_to_8", "png_set_expand_gray_1_2_4_to_8"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
