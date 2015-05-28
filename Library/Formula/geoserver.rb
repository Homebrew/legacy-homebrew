require 'formula'

class Geoserver < Formula
  homepage 'http://geoserver.org/'
  version = '2.7.1'
  url "https://downloads.sourceforge.net/project/geoserver/GeoServer/#{version}/geoserver-#{version}-bin.zip"
  sha1 '9843864a5fa3d0bf20a92bc548565e3cfab876c9'

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
