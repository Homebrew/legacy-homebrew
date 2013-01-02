require 'formula'

class Pstoedit < Formula
  homepage 'http://www.pstoedit.net'
  url 'https://sourceforge.net/projects/pstoedit/files/pstoedit/3.61/pstoedit-3.61.tar.gz'
  sha1 '426f3746ecb441caa0db401d5880e1ac04a399d5'

  depends_on 'pkg-config' => :build
  depends_on 'plotutils'
  depends_on 'ghostscript'
  depends_on 'imagemagick'

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
