require 'formula'

class Neo4j < Formula
  homepage 'http://neo4j.org'
  url 'http://dist.neo4j.org/neo4j-community-2.0.2-unix.tar.gz'
  sha1 '7ac10aa3cb327580ed3abb7b42921070ffc1ca09'
  version '2.0.2'

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Install jars in libexec to avoid conflicts
    libexec.install Dir['*']

    # Symlink binaries
    bin.install_symlink Dir["#{libexec}/bin/neo4j{,-shell}"]

    # Adjust UDC props
    open("#{libexec}/conf/neo4j-wrapper.conf", 'a') { |f|
      f.puts "wrapper.java.additional.4=-Dneo4j.ext.udc.source=homebrew"

      # suppress the empty, focus-stealing java gui
      f.puts "wrapper.java.additional=-Djava.awt.headless=true"
    }
  end

  def caveats; <<-EOS.undent
    Quick-start guide:

        1. Start the server manually:
            neo4j start

        2. Open the neo4j browser:
            open http://localhost:7474/browser/

        3. Start exploring the REST API:
            curl -v http://localhost:7474/db/data/

        4. Stop:
            neo4j stop

    To launch on startup, install launchd-agent to ~/Library/LaunchAgents/ with:
        neo4j install

    If this is an upgrade, see:
        #{libexec}/UPGRADE.txt

    The manual can be found in:
        #{libexec}/doc/

    You may need to set JAVA_HOME for Java 7 in your shell profile:
        export JAVA_HOME="$(/usr/libexec/java_home -v 1.7)"

    EOS
  end
end
