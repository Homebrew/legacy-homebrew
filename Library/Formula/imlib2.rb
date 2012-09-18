require 'formula'

class Imlib2 < Formula
  homepage 'http://sourceforge.net/projects/enlightenment/files/'
  url 'http://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.4.5/imlib2-1.4.5.tar.bz2'
  sha1 'af86a2c38f4bc3806db57e64e74dc9814ad474a0'

  depends_on 'pkg-config' => :build
  depends_on :freetype
  depends_on :libpng => :recommended
  depends_on 'jpeg' => :recommended

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-amd64=no",
                          "--without-x"
    system "make install"
  end

  def test
    mktemp do
      system "#{bin}/imlib2_conv", \
        "/System/Library/Frameworks/SecurityInterface.framework/Versions/A/Resources/Key_Large.png", \
        "imlib2_test.jpg"
    end
  end
end
