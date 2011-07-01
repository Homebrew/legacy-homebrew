require 'formula'

class Neo4j < Formula
  head 'http://dist.neo4j.org/neo4j-community-1.4-SNAPSHOT-unix.tar.gz'
  url 'http://dist.neo4j.org/neo4j-community-1.4-SNAPSHOT-unix.tar.gz'
  #url 'http://dist.neo4j.org/neo4j-community-1.4.M05-unix.tar.gz'
  version 'community-1.4-SNPASHOT'
  homepage 'http://neo4j.org'


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
