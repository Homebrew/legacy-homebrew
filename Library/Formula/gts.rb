require 'formula'

class Gts < Formula
  url 'http://downloads.sourceforge.net/project/gts/gts/0.7.6/gts-0.7.6.tar.gz'
  homepage 'http://gts.sourceforge.net/'
  md5 '9f710aefd2ed9b3cc1b1216171fc5a8a'
  depends_on 'glib'
  depends_on 'gettext'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make install"
  end
end
