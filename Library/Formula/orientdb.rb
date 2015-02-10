require 'formula'

class Orientdb < Formula
  homepage 'http://www.orientdb.org/index.htm'
  url 'http://www.orientechnologies.com/download.php?email=unknown@unknown.com&file=orientdb-community-2.0.2.tar.gz&os=mac'
  version '2.0.2'
  sha1 '784789b88387007e9af5486d8ceac3d0d24e653d'

  bottle do
    cellar :any
    sha1 "63145036db21d715743474aa71c3ac603bd367a2" => :yosemite
    sha1 "aaa392994e90e1942f015bf22a7389f78c151f57" => :mavericks
    sha1 "6da5366bdb171b75bbfa3623029ba8190c03e907" => :mountain_lion
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
