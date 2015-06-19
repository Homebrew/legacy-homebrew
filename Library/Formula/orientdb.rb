require 'formula'

class Orientdb < Formula
  desc "Graph database"
  homepage 'http://www.orientdb.org/index.htm'
  url 'http://www.orientechnologies.com/download.php?email=unknown@unknown.com&file=orientdb-community-2.0.11.tar.gz&os=mac'
  version '2.0.11'
  sha1 '812df4b971c3afc7bc9760b7de9bcc6680c060f0'

  bottle do
    cellar :any
    sha256 "1b523ed265373bbd8a8f1422adc33b64b0b6c1a9fc71fc5512eedbfcb545a3b8" => :yosemite
    sha256 "ca389a51b889765408e328b5d37dcbf110c1a011155672042493919e968c92cc" => :mavericks
    sha256 "1058060af5d03faec8876ec080b127b4196f17e3802d9f01c982a3200f7c8e9a" => :mountain_lion
  end

  # Fixing OrientDB init scripts
  patch do
    url "https://gist.githubusercontent.com/maggiolo00/84835e0b82a94fe9970a/raw/1ed577806db4411fd8b24cd90e516580218b2d53/orientdbsh"
    sha1 "280284f3a8b6e280e46078b746f8250aa5648979"
  end

  def install
    rm_rf Dir['{bin,benchmarks}/*.{bat,exe}']

    inreplace %W[bin/orientdb.sh bin/console.sh bin/gremlin.sh],
      '"YOUR_ORIENTDB_INSTALLATION_PATH"', libexec

    chmod 0755, Dir["bin/*"]
    libexec.install Dir['*']

    mkpath "#{libexec}/log"
    touch "#{libexec}/log/orientdb.err"
    touch "#{libexec}/log/orientdb.log"

    bin.install_symlink "#{libexec}/bin/orientdb.sh" => 'orientdb'
    bin.install_symlink "#{libexec}/bin/console.sh" => 'orientdb-console'
    bin.install_symlink "#{libexec}/bin/gremlin.sh" => 'orientdb-gremlin'
  end

  def caveats
    "Use `orientdb <start | stop | status>`, `orientdb-console` and `orientdb-gremlin`."
  end
end
