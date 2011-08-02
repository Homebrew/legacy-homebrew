require 'formula'

class Goaccess < Formula
  url 'http://downloads.sourceforge.net/project/goaccess/0.4.2/goaccess-0.4.2.tar.gz'
  homepage 'http://goaccess.prosoftcorp.com/'
  md5 '7d7707c294c949d612e451da2f003c37'
  head 'git://goaccess.git.sourceforge.net/gitroot/goaccess/goaccess'

  depends_on 'geoip'
  depends_on 'glib'

  def install
    system "./configure", "--enable-geoip",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
