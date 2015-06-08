require 'formula'

class Geoserver < Formula
  desc "Java server to share and edit geospatial data"
  homepage 'http://geoserver.org/'
  url 'https://downloads.sourceforge.net/project/geoserver/GeoServer/2.7.1/geoserver-2.7.1-bin.zip'
  sha256 '37a48e344ad17ee8dfd300746789f82c4617c8d1800d772cb59305cd8b7c6845'

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
