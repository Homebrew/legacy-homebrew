class Orientdb < Formula
  desc "Graph database"
  homepage "https://orientdb.com"
  url "https://orientdb.com/download.php?email=unknown@unknown.com&file=orientdb-community-2.1.9.tar.gz&os=mac"
  version "2.1.9"
  sha256 "224bb729cfb46bcda8916a1fbb8f0d77e05b0ba24d0018cddb17f292e04cd249"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f04b2646e4deae8be36ebc18eead46982b11f53aa2652414946ca221f09e3f8" => :el_capitan
    sha256 "c4a54eddf8503b82fd8452d6c502ca647cfe7469d4bf1a54bbfc9422536c3fc2" => :yosemite
    sha256 "b83e829bf06ba825b60058f0fd2484b2df3cfbdf7d3c24ed90879e47579c5b1b" => :mavericks
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
