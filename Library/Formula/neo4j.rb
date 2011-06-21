require 'formula'

class Neo4j < Formula
  head 'http://builder.neo4j.org/guestAuth/repository/download/bt65/.lastSuccessful/standalone/neo4j-community-1.4-SNAPSHOT-unix.tar.gz'
  url 'http://dist.neo4j.org/neo4j-community-1.4.M04-unix.tar.gz'
  version 'community-1.4-M05'
  homepage 'http://neo4j.org'


  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Fix the permissions on the global settings file.
    chmod 0644, Dir["config"]

    # Install jars in libexec to avoid conflicts
    #prefix.install %w{ NOTICE.txt LICENSE.txt README.txt }
    libexec.install Dir['*']

    # Symlink binaries
    bin.mkpath
    ln_s "#{libexec}/bin/neo4j", bin+"neo4j"
  end
end
