class FleetDb < Formula
  desc "Schema-free database optimized for agile development"
  homepage "http://fleetdb.org"
  url "https://fleetdb.s3.amazonaws.com/fleetdb-standalone-0.2.0.jar"
  sha256 "240df0ee690eedf5eed1fd791eca34f18d36852a88a38a521ce9d03748de07a8"

  bottle :unneeded

  def install
    libexec.install "fleetdb-standalone-#{version}.jar"
    (bin+"fleetdb-server").write <<-EOS.undent
      #!/bin/sh
      java -cp "#{libexec}/fleetdb-standalone-#{version}.jar" fleetdb.server "$@"
    EOS
  end

  def caveats; <<-EOS.undent
    To start a FleetDB server:
      fleetdb-server -f /path/to/data.fdb
    EOS
  end
end
