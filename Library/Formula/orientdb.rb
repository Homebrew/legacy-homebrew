class Orientdb < Formula
  desc "Graph database"
  homepage "https://orientdb.com"
  url "https://orientdb.com/download.php?email=unknown@unknown.com&file=orientdb-community-2.1.13.tar.gz&os=mac"
  version "2.1.13"
  sha256 "33f68db630dae88c097bdc5444918de81143c9a6eb1bf5c2aee045df392deb6e"

  bottle do
    cellar :any_skip_relocation
    sha256 "839bd7d0e4f498d4db1dd76a1c06aa79f2140310af0eba4a564c0f8d8e5e49d8" => :el_capitan
    sha256 "ed07b75759fc93914f8591fc9669513a6236ded2e399c808da912a5d808ac9e0" => :yosemite
    sha256 "10a4bd26417fe23c03d86475cc237690e4b2529254fa82f01114265cdab9643a" => :mavericks
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
