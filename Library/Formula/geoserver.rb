require 'formula'

class Geoserver < Formula
  homepage 'http://geoserver.org/'
  url 'http://downloads.sourceforge.net/project/geoserver/GeoServer/2.3.5/geoserver-2.3.5-bin.zip'
  sha1 '56b610fb031d6729a40a5d94940e9aba54079e21'

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
