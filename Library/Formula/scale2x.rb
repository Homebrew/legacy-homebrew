require 'formula'

class Scale2x < Formula
  homepage 'http://http://scale2x.sourceforge.net'
  url 'http://sourceforge.net/projects/scale2x/files/scale2x/2.4/scale2x-2.4.tar.gz'
  #version '2.4'
  sha1 '30bbd674dcdf134a58b34e75f87ed05bd716d484'

  depends_on :x11

  def install
    #This function was renamed in libpng
    inreplace 'file.c', 'png_set_gray_1_2_4_to_8', 'png_set_expand_gray_1_2_4_to_8'
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    #Double the size of an image
    system "scalerx",
    "/System/Library/Frameworks/SecurityInterface.framework/Versions/A/Resources/Key_Large.png",
    "/tmp/Key_Large2.png"
    #Check if the output file exists (could check size in future tests)
    system "file", "/tmp/Key_Large2.png"
  end
end
