class Geoserver < Formula
  desc "Java server to share and edit geospatial data"
  homepage "http://geoserver.org/"
  url "https://downloads.sourceforge.net/project/geoserver/GeoServer/2.7.1.1/geoserver-2.7.1.1-bin.zip"
  sha256 "4c584ae1e586736533e3a4bd9969eb0d180ec683cf79f2aff8512075b742da60"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    (bin/"geoserver").write <<-EOS.undent
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
    assert_match /geoserver path/, shell_output("#{bin}/geoserver")
  end
end
