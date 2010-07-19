require 'formula'

class FleetDb <Formula
  url 'http://fleetdb.s3.amazonaws.com/fleetdb-standalone-0.2.0.jar'
  version '0.2.0'
  homepage 'http://fleetdb.org'
  md5 'e7c0b9dd61650300e82da46bab6ee560'

  def install
    prefix.mkpath
    prefix.install Dir['*']
    (bin+'fleetdb-server').write <<-SCRIPT
#!/bin/sh
java -cp #{prefix}/fleetdb-standalone-0.2.0.jar fleetdb.server $@
SCRIPT
  end

  def caveats; <<-CAVAETS
To start a FleetDB server:
    fleetdb-server -f /path/to/data.fdb
CAVAETS
  end
end
