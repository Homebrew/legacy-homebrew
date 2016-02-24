class Geoserver < Formula
  desc "Java server to share and edit geospatial data"
  homepage "http://geoserver.org/"
  url "https://downloads.sourceforge.net/project/geoserver/GeoServer/2.8.1/geoserver-2.8.1-bin.zip"
  sha256 "c0d0a821a6997cad7c604cc466355fa63df296d64045ebd9ac796b74631ffd90"

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
    EOS
  end

  test do
    assert_match /geoserver path/, shell_output("#{bin}/geoserver")
  end
end
