require 'formula'

class Svg2pdf < Formula
  url 'http://cairographics.org/snapshots/svg2pdf-0.1.3.tar.gz'
  homepage 'http://cairographics.org/'
  md5 '0059ba059ff89931cf37720fcd102d8f'

  depends_on 'pkg-config' => :build
  depends_on 'libsvg-cairo'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
