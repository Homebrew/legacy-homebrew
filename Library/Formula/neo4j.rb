require "formula"

class Neo4j < Formula
  homepage "http://neo4j.org"
  url "http://dist.neo4j.org/neo4j-community-2.0.3-unix.tar.gz"
  sha1 "250b8d8bcb11ea8d9d5bc96cb07390e783c38c28"
  version "2.0.3"

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Install jars in libexec to avoid conflicts
    libexec.install Dir["*"]

    # Symlink binaries
    bin.install_symlink Dir["#{libexec}/bin/neo4j{,-shell}"]

    # Adjust UDC props
    open("#{libexec}/conf/neo4j-wrapper.conf", "a") { |f|
      f.puts "wrapper.java.additional.4=-Dneo4j.ext.udc.source=homebrew"

      # suppress the empty, focus-stealing java gui
      f.puts "wrapper.java.additional=-Djava.awt.headless=true"
    }
  end
end
