require 'formula'

class Geoserver < Formula
  homepage 'http://geoserver.org/'
  url 'http://sourceforge.net/projects/geoserver/files/GeoServer/2.3.2/geoserver-2.3.2-bin.zip'
  sha1 '86a3d0fe368867db88eeb401523cb19e95115e2d'

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
end
