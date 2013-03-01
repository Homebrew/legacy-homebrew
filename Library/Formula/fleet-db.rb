require 'formula'

class FleetDb < Formula
  homepage 'http://fleetdb.org'
  url 'http://fleetdb.s3.amazonaws.com/fleetdb-standalone-0.2.0.jar'
  sha1 'dcc8f10ba697e7603c4c6ae9ba93913f83de87dd'

  def install
    libexec.install "fleetdb-standalone-0.2.0.jar"
    (bin+'fleetdb-server').write <<-EOS.undent
      #!/bin/sh
      java -cp "#{libexec}/fleetdb-standalone-0.2.0.jar" fleetdb.server "$@"
    EOS
  end

  def caveats; <<-EOS.undent
    To start a FleetDB server:
      fleetdb-server -f /path/to/data.fdb
    EOS
  end
end
