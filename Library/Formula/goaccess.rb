require 'formula'

class Goaccess < Formula
  url 'http://downloads.sourceforge.net/project/goaccess/0.4.2/goaccess-0.4.2.tar.gz'
  homepage 'http://goaccess.prosoftcorp.com/'
  md5 '7d7707c294c949d612e451da2f003c37'
  head 'git://goaccess.git.sourceforge.net/gitroot/goaccess/goaccess'

  depends_on 'glib'
  depends_on 'geoip' if ARGV.include? "--enable-geoip"

  def options
    [['--enable-geoip', "Enable IP location information using GeoIP"]]
  end

  def install
    args = ["--prefix=#{prefix}",
            "--disable-debug",
            "--disable-dependency-tracking"]

    args << "--enable-geoip" if ARGV.include? '--enable-geoip'

    system "./configure", *args
    system "make install"
  end
end
