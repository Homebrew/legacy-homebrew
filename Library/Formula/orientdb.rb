class Orientdb < Formula
  desc "Graph database"
  homepage "http://www.orientdb.org/index.htm"
  url "http://www.orientechnologies.com/download.php?email=unknown@unknown.com&file=orientdb-community-2.1.0.tar.gz&os=mac"
  version "2.1.0"
  sha256 "fc177c14639b6516044c5eb4900d66e2a6b9abc91b687d53c967171cd19e5197"

  bottle do
    cellar :any
    sha256 "86a8f0f9e8bc98bc5e12304fa7b3be91ec6665f1948a8008c1423ea46434b806" => :yosemite
    sha256 "55bbf42042f2d80fdf3aa984a41d325dcb0abfa04136e8d320d02adde43d6fa0" => :mavericks
    sha256 "d84a89f602cb8cd9e0948f2ad1acb3a47c52fd3fe56abbbea59e64dc97a84cc1" => :mountain_lion
  end

  # Fixing OrientDB init scripts
  patch do
    url "https://gist.githubusercontent.com/maggiolo00/84835e0b82a94fe9970a/raw/1ed577806db4411fd8b24cd90e516580218b2d53/orientdbsh"
    sha256 "d8b89ecda7cb78c940b3c3a702eee7b5e0f099338bb569b527c63efa55e6487e"
  end

  def install
    rm_rf Dir["{bin,benchmarks}/*.{bat,exe}"]

    inreplace %W[bin/orientdb.sh bin/console.sh bin/gremlin.sh],
      '"YOUR_ORIENTDB_INSTALLATION_PATH"', libexec

    chmod 0755, Dir["bin/*"]
    libexec.install Dir["*"]

    mkpath "#{libexec}/log"
    touch "#{libexec}/log/orientdb.err"
    touch "#{libexec}/log/orientdb.log"

    bin.install_symlink "#{libexec}/bin/orientdb.sh" => "orientdb"
    bin.install_symlink "#{libexec}/bin/console.sh" => "orientdb-console"
    bin.install_symlink "#{libexec}/bin/gremlin.sh" => "orientdb-gremlin"
  end

  def caveats
    "Use `orientdb <start | stop | status>`, `orientdb-console` and `orientdb-gremlin`."
  end
end
