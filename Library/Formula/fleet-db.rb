require 'formula'

class FleetDb < Formula
  url 'http://fleetdb.s3.amazonaws.com/fleetdb-standalone-0.2.0.jar'
  homepage 'http://fleetdb.org'
  md5 'e7c0b9dd61650300e82da46bab6ee560'

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
