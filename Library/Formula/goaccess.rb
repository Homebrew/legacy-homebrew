require 'formula'

class Goaccess < Formula
  homepage 'http://goaccess.prosoftcorp.com/'
  url 'http://downloads.sourceforge.net/project/goaccess/0.4.2/goaccess-0.4.2.tar.gz'
  sha1 '6fdfef45eaa4bc08ac2169289bb50a0b287b47a1'

  head 'git://goaccess.git.sourceforge.net/gitroot/goaccess/goaccess'

  option 'enable-geoip', "Enable IP location information using GeoIP"

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'geoip' if build.include? "enable-geoip"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--enable-geoip" if build.include? "enable-geoip"

    system "./configure", *args
    system "make install"
  end
end
