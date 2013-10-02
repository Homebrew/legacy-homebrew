require 'formula'

class Geoserver < Formula
  homepage 'http://geoserver.org/'
  url 'http://downloads.sourceforge.net/project/geoserver/GeoServer/2.4.0/geoserver-2.4.0-bin.zip'
  sha1 '0439b7d7a133dd738da042a82e8667325e22ef92'

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
