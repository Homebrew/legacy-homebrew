require 'formula'

class Geoserver < Formula
  homepage 'http://geoserver.org/'
  url 'http://sourceforge.net/projects/geoserver/files/GeoServer/2.2.3/geoserver-2.2.3-bin.zip'
  sha1 '3a3bb97ecc6c1a798279a89a3ad6c44a13fe4d01'

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
