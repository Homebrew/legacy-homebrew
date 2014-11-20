require 'formula'

class Orientdb < Formula
  homepage 'http://www.orientdb.org/index.htm'
  url 'http://www.orientdb.org/portal/function/portal/download/unknown@unknown.com/-/-/-/-/-/orientdb-community-1.7.9.tar.gz/false/false/mac'
  version '1.7.9'
  sha1 '85e6e13bde4e04fb66828faf2bee6462a4b39f1e'

  devel do
    url 'http://www.orientechnologies.com/download.php?email=unknown@unknown.com&file=orientdb-community-2.0-M3.tar.gz&os=mac'
    version '2.0-M3'
    sha1 '8e5f9410eed54e6ea4b3aa5d527e6ea0262f790d'
  end


  bottle do
    cellar :any
    revision 1
    sha1 "346ac9185dbfd151cc462fa28421e23e76496261" => :yosemite
    sha1 "1ed5c993c6bdbe3ffa2d52f2efe0fe9199c3615f" => :mavericks
    sha1 "7068f8642028aaa7c1af31b182d877ecdcc2577a" => :mountain_lion
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
