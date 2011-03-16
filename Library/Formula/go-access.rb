require 'formula'

class GoAccess < Formula
  url 'http://sourceforge.net/projects/goaccess/files/0.4.1/goaccess-0.4.1.tar.gz'
  homepage 'http://goaccess.prosoftcorp.com/'
  sha1 'f68336fc49eb4907262f53956d4b88d5573a861e'

  depends_on 'glib'
  depends_on 'geoip' if ARGV.include? "--enable-geoip"

  def options
    [['--enable-geoip', "Enable IP location information using GeoIP"]]
  end

  def install
    # Don't attempt to link to librt since it doesn't exist on OSX.
    inreplace "Makefile.in", "LIBS = @GLIB2_LIBS@ -lrt", "LIBS = @GLIB2_LIBS@"

    args = ["--prefix=#{prefix}",
            "--disable-debug",
            "--disable-dependency-tracking"]

    args << "--enable-geoip" if ARGV.include? '--enable-geoip'

    system "./configure", *args
    system "make install"
  end
end
