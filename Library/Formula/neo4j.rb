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
