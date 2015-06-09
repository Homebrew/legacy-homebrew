require "formula"

class Neo4j < Formula
  desc "Robust (fully ACID) transactional property graph database"
  homepage "http://neo4j.org"
  url "http://dist.neo4j.org/neo4j-community-2.2.2-unix.tar.gz"
  sha1 "b5b12d7815ffa7d232c29d0021b5d8629c243073"
  version "2.2.2"

  option "with-neo4j-shell-tools", "Add neo4j-shell-tools to the standard neo4j-shell"

  resource "neo4j-shell-tools" do
    url "http://dist.neo4j.org/jexp/shell/neo4j-shell-tools_2.2.zip"
    sha1 "5c1d4d46660149291ca4f484591c25c25be82c5b"
  end

  devel do
    url "http://dist.neo4j.org/neo4j-community-2.3.0-M02-unix.tar.gz"
    sha1 "1bcdc0272bad230314d827cea7c8279b5f7ab4b0"
    version "2.3.0-M02"
  end

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Install jars in libexec to avoid conflicts
    libexec.install Dir["*"]

    # Symlink binaries
    bin.install_symlink Dir["#{libexec}/bin/neo4j{,-shell,-import}"]

    # Eventually, install neo4j-shell-tools
    # omiting "opencsv-2.3.jar" because it already comes with neo4j (see libexec/lib)
    if build.with? "neo4j-shell-tools"
      resource("neo4j-shell-tools").stage {
        (libexec/"lib").install "geoff-0.5.0.jar", "import-tools-2.2.jar", "mapdb-0.9.3.jar"
      }
    end

    # Adjust UDC props
    open("#{libexec}/conf/neo4j-wrapper.conf", "a") { |f|
      f.puts "wrapper.java.additional.4=-Dneo4j.ext.udc.source=homebrew"

      # suppress the empty, focus-stealing java gui
      f.puts "wrapper.java.additional=-Djava.awt.headless=true"
    }
  end
end
