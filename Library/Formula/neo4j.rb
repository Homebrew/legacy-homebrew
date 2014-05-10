require 'formula'

class Neo4j < Formula
  homepage 'http://neo4j.org'
  url 'http://dist.neo4j.org/neo4j-community-2.0.2-unix.tar.gz'
  sha1 '7ac10aa3cb327580ed3abb7b42921070ffc1ca09'
  version '2.0.2'

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Install jars in libexec to avoid conflicts
    libexec.install Dir['*']

    # Symlink binaries
    bin.install_symlink Dir["#{libexec}/bin/neo4j{,-shell}"]

    # Adjust UDC props
    open("#{libexec}/conf/neo4j-wrapper.conf", 'a') { |f|
      f.puts "wrapper.java.additional.4=-Dneo4j.ext.udc.source=homebrew"

      # suppress the empty, focus-stealing java gui
      f.puts "wrapper.java.additional=-Djava.awt.headless=true"
    }
  end
end
