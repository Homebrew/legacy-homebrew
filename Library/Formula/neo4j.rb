class Neo4j < Formula
  desc "Robust (fully ACID) transactional property graph database"
  homepage "http://neo4j.com"
  url "http://dist.neo4j.org/neo4j-community-2.2.6-unix.tar.gz"
  version "2.2.6"
  sha256 "77f8371318c843bdd8fbd5f95be95e9a1467bb84030d4a3ff9dcec805b4003b9"

  devel do
    url "http://dist.neo4j.org/neo4j-community-2.3.0-RC1-unix.tar.gz"
    sha256 "fed10ec7d7c0a0c39041a8079672812962f3ceff053f050617b42b5d0bd22ae9"
    version "2.3.0-RC1"
  end

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Install jars in libexec to avoid conflicts
    libexec.install Dir["*"]

    # Symlink binaries
    bin.install_symlink Dir["#{libexec}/bin/neo4j{,-shell,-import}"]

    # Adjust UDC props
    open("#{libexec}/conf/neo4j-wrapper.conf", "a") do |f|
      f.puts "wrapper.java.additional.4=-Dneo4j.ext.udc.source=homebrew"

      # suppress the empty, focus-stealing java gui
      f.puts "wrapper.java.additional=-Djava.awt.headless=true"
    end
  end
end
