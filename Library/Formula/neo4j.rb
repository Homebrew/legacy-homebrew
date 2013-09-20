require 'formula'

class Neo4j < Formula
  homepage 'http://neo4j.org'
  url 'http://dist.neo4j.org/neo4j-community-1.9.3-unix.tar.gz'
  sha1 '503dfa4409708922f98247d0a8c888d6356d5d1c'
  version 'community-1.9.3-unix'

  devel do
    url 'http://dist.neo4j.org/neo4j-community-2.0.0-M05-unix.tar.gz'
    sha1 '30a1b1a93ad6923cbce3563779faff23f25a100c'
    version 'community-2.0.0-M05-unix'
  end

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Fix the permissions on the global settings file.
    chmod 0644, Dir["config"]

    # Install jars in libexec to avoid conflicts
    libexec.install Dir['*']

    # Symlink binaries
    bin.install_symlink Dir["#{libexec}/bin/neo4j{,-shell}"]

    # Adjust UDC props
    open("#{libexec}/conf/neo4j-wrapper.conf", 'a') { |f|
      f.puts "wrapper.java.additional.4=-Dneo4j.ext.udc.source=homebrew"
    }
  end

  def caveats; <<-EOS.undent
    Quick-start guide:

        1. Start the server manually:
            neo4j start

        2. Open webadmin:
            open http://localhost:7474/webadmin/

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

    You may need to add JAVA_HOME to your shell profile:
        export JAVA_HOME="$(/usr/libexec/java_home)"

    EOS
  end
end
