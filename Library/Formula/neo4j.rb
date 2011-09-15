require 'formula'

class Neo4j < Formula
  head 'http://dist.neo4j.org/neo4j-community-1.5-SNAPSHOT-unix.tar.gz'
  url 'http://dist.neo4j.org/neo4j-community-1.4-unix.tar.gz'
  version 'community-1.4'
  homepage 'http://neo4j.org'
  md5 'a176c80283c3f4d3d71ee2f5c8bfa550'

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Fix the permissions on the global settings file.
    chmod 0644, Dir["config"]

    # Install jars in libexec to avoid conflicts
    libexec.install Dir['*']

    # Symlink binaries
    bin.mkpath
    ln_s "#{libexec}/bin/neo4j", bin+"neo4j"
  end
end
