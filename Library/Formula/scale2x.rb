require 'formula'

class Scale2x < Formula
  homepage 'http://scale2x.sourceforge.net'
  url 'http://sourceforge.net/projects/scale2x/files/scale2x/2.4/scale2x-2.4.tar.gz'
  sha1 '30bbd674dcdf134a58b34e75f87ed05bd716d484'

  depends_on :libpng

  def install
    # This function was renamed in current versions of libpng.
    inreplace 'file.c', 'png_set_gray_1_2_4_to_8', 'png_set_expand_gray_1_2_4_to_8'
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
