require "formula"

class Neo4j < Formula
  homepage "http://neo4j.org"
  url "http://dist.neo4j.org/neo4j-community-2.1.6-unix.tar.gz"
  sha1 "6f790bb9dc50e50ba2409101f809e6b3a6cd709e"
  version "2.1.6"

  devel do
    url "http://dist.neo4j.org/neo4j-community-2.2.0-M02-unix.tar.gz"
    sha1 "1ccc22000ea52e6f0d6c802fbb12da5c29b34607"
    version "2.2.0-M02"
  end

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Install jars in libexec to avoid conflicts
    libexec.install Dir["*"]

    # Symlink binaries
    bin.install_symlink Dir["#{libexec}/bin/neo4j{,-shell}"]

    if build.devel?
      bin.install_symlink libexec/"bin/neo4j-import"
    end

    # Adjust UDC props
    open("#{libexec}/conf/neo4j-wrapper.conf", "a") { |f|
      f.puts "wrapper.java.additional.4=-Dneo4j.ext.udc.source=homebrew"

      # suppress the empty, focus-stealing java gui
      f.puts "wrapper.java.additional=-Djava.awt.headless=true"
    }
  end
end
