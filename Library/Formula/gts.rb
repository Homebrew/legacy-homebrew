require 'formula'

class Gts < Formula
  homepage 'http://gts.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/gts/gts/0.7.6/gts-0.7.6.tar.gz'
  md5 '9f710aefd2ed9b3cc1b1216171fc5a8a'

  option :universal

  depends_on 'gettext'
  depends_on 'glib'

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make install"
  end
end
