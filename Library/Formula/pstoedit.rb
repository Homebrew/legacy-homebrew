require 'formula'

class Pstoedit < Formula
  url 'http://downloads.sourceforge.net/project/pstoedit/pstoedit/3.50/pstoedit-3.50.tar.gz'
  homepage 'http://www.pstoedit.net'
  md5 '97d649305ad90fab7a569154f17e0916'

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
