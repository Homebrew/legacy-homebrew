require 'formula'

class Goaccess < Formula
  url 'http://downloads.sourceforge.net/project/goaccess/0.4.2/goaccess-0.4.2.tar.gz'
  homepage 'http://goaccess.prosoftcorp.com/'
  sha1 '6fdfef45eaa4bc08ac2169289bb50a0b287b47a1'
  head 'git://goaccess.git.sourceforge.net/gitroot/goaccess/goaccess'

  depends_on 'pkg-config' => :build
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
