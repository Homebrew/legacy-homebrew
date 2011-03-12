require 'formula'

class Pstoedit <Formula
  url 'http://downloads.sourceforge.net/project/pstoedit/pstoedit/3.50/pstoedit-3.50.tar.gz'
  homepage 'http://www.pstoedit.net'
  md5 '97d649305ad90fab7a569154f17e0916'

  depends_on 'libpng'
  depends_on 'plotutils'
  depends_on 'imagemagick'
  depends_on 'ghostscript'

  def install
    ENV.deparallelize

    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
