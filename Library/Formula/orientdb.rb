class Orientdb < Formula
  desc "Graph database"
  homepage "http://www.orientdb.org/index.htm"
  url "http://www.orientechnologies.com/download.php?email=unknown@unknown.com&file=orientdb-community-2.0.11.tar.gz&os=mac"
  version "2.0.11"
  sha256 "da6935761823f1e92aa9e10afd4ce47d9ab192aa4fdffef046bdd8696c80da92"

  bottle do
    cellar :any
    sha256 "2d241333db53b9d47556335b32c31de6715c1b005a97b1ac8d820a57f68a6fea" => :yosemite
    sha256 "7f1ad7da5cb2624a27a6f86ca89ae7799359c0709639696690742b006365e827" => :mavericks
    sha256 "5d58fcdb483a53695cd947a5835277d4216aa8735ff0339715a791b1d52373ca" => :mountain_lion
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
