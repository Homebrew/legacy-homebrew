require 'formula'

class Orientdb < Formula
  homepage 'http://www.orientdb.org/index.htm'
  url 'http://www.orientechnologies.com/download.php?email=unknown@unknown.com&file=orientdb-community-2.0.1.tar.gz&os=mac'
  version '2.0.1'
  sha1 '6e31c99406453b7f0fb115f83a7cfd20eb1e318f'

  bottle do
    cellar :any
    sha1 "99a13c6db4471d17f9aa2722fb6a81a81b2f00bf" => :yosemite
    sha1 "70fd98d6e48743a4a1abdbf306f48c8212fd3256" => :mavericks
    sha1 "d8442c4547b6a77cf767e7618b1319a6fc3f1c4f" => :mountain_lion
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
