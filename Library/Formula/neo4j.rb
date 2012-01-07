require 'formula'

class Neo4j < Formula
  url 'http://dist.neo4j.org/neo4j-community-1.6.M02-unix.tar.gz'
  version 'community-1.6.M02'
  homepage 'http://neo4j.org'
  md5 'd90e08da7de51d3c56b56688a731fc7a'

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
    ln_s "#{libexec}/bin/neo4j-shell", bin+"neo4j-shell"
  end
end
