class Neo4j < Formula
  desc "Robust (fully ACID) transactional property graph database"
  homepage "http://neo4j.com"
  url "http://dist.neo4j.org/neo4j-community-2.2.5-unix.tar.gz"
  version "2.2.5"
  sha256 "7fadc119f465a3d6adceb610401363fb158a5ed25081f9893d4f56ac4989a998"

  devel do
    url "http://dist.neo4j.org/neo4j-community-2.3.0-M03-unix.tar.gz"
    sha256 "cd47ae541a0c5da0d82212c30c1c2fb19ea91ddb1b174346c120e596e04b5dfc"
    version "2.3.0-M03"
  end

  option "with-neo4j-shell-tools", "Add neo4j-shell-tools to the standard neo4j-shell"

  resource "neo4j-shell-tools" do
    url "http://dist.neo4j.org/jexp/shell/neo4j-shell-tools_2.2.zip"
    sha256 "e295f724b6c5e35db5d471eefc976bd5adcd002763722c726885455e3f38f2ca"
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
      resource("neo4j-shell-tools").stage do
        (libexec/"lib").install "geoff-0.5.0.jar", "import-tools-2.2.jar", "mapdb-0.9.3.jar"
      end
    end

    # Adjust UDC props
    open("#{libexec}/conf/neo4j-wrapper.conf", "a") do |f|
      f.puts "wrapper.java.additional.4=-Dneo4j.ext.udc.source=homebrew"

      # suppress the empty, focus-stealing java gui
      f.puts "wrapper.java.additional=-Djava.awt.headless=true"
    end
  end
end
