require 'formula'

class Neo4j < Formula
  url 'http://dist.neo4j.org/neo4j-community-1.5-unix.tar.gz'
  version 'community-1.5'
  homepage 'http://neo4j.org'
  md5 '7a48947c8bccef033098e5872510cb72'

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
