require 'formula'

class Neo4j < Formula
  head 'http://dist.neo4j.org/neo4j-community-1.5-SNAPSHOT-unix.tar.gz'
  url 'http://dist.neo4j.org/neo4j-community-1.4.1-unix.tar.gz'
  version 'community-1.4.1'
  homepage 'http://neo4j.org'
  md5 '3e26b39d498bd15853a299e10486eb90'

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
