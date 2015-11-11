require 'formula'

class Geoserver < Formula
  desc "Java server to share and edit geospatial data"
  homepage 'http://geoserver.org/'
  url 'https://downloads.sourceforge.net/project/geoserver/GeoServer/2.7.2/geoserver-2.7.2-bin.zip'
  sha256 '2fffa49bc46743673e4fd678873ff2891e1a31471a10758aa0603c30fea2b1eb'

  bottle :unneeded

  def install
    libexec.install Dir['*']
    (bin/'geoserver').write <<-EOS.undent
      #!/bin/sh
      if [ -z "$1" ]; then
        echo "Usage: $ geoserver path/to/data/dir"
      else
        cd "#{libexec}" && java -DGEOSERVER_DATA_DIR=$1 -jar start.jar
      fi
    EOS
  end

  def caveats; <<-EOS.undent
    To start geoserver:
      geoserver path/to/data/dir
    See the Geoserver homepage for more setup information:
      brew home geoserver
    EOS
  end

  test do
    assert_match /geoserver path/, shell_outout("#{bin}/geoserver")
  end
end
