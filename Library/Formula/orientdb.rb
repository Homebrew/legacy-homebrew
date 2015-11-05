class Orientdb < Formula
  desc "Graph database"
  homepage "https://orientdb.com"
  url "https://orientdb.com/download.php?email=unknown@unknown.com&file=orientdb-community-2.1.5.tar.gz&os=mac"
  version "2.1.5"
  sha256 "3bec2b7a1baf60bd6cf5dd1b7b6f1a9ac47b71515aefbcbf560a2736b36015be"

  bottle do
    cellar :any_skip_relocation
    sha256 "df6ce1cd1be77322e0d4614e3251fca8d20e5020d540208d500458166ac9d438" => :el_capitan
    sha256 "9b1b5ef6ea1cfeb24e866c37c9eaf65f615e8d20f68b114888dfef6a42360eee" => :yosemite
    sha256 "b3223c59235cfb7729400b8824bbc239ecd00146ed37f54fdee826bf777d7beb" => :mavericks
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
