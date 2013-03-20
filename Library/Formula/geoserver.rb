require 'formula'

class Geoserver < Formula
  homepage 'http://geoserver.org/'
  url 'http://sourceforge.net/projects/geoserver/files/GeoServer/2.3.0/geoserver-2.3.0-bin.zip'
  sha1 '3e21c5d39475a5d1e8cfa69d09cf2189166507a5'

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
