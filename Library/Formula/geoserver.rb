require 'formula'

class Geoserver < Formula
  homepage 'http://geoserver.org/'
  url 'http://sourceforge.net/projects/geoserver/files/GeoServer/2.1.4/geoserver-2.1.4-bin.zip'
  sha1 'dcea0ce5bf9fc97f010e4ba019cc32151b368936'

  def script; <<-EOS.undent
      #!/bin/sh
      if [ -z "$1" ]; then
        echo "Usage: $ geoserver path/to/data/dir"
      else
        cd #{libexec} && java -DGEOSERVER_DATA_DIR=$1 -jar start.jar
      fi
    EOS
  end

  def install
    libexec.install Dir['*']
    (bin+'geoserver').write script
  end

  def caveats; <<-EOS.undent
      To start geoserver
        geoserver path/to/data/dir

      See the Geoserver homepage for more setup information:
        brew home geoserver
    EOS
  end

end
