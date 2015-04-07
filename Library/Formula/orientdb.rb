require 'formula'

class Orientdb < Formula
  homepage 'http://www.orientdb.org/index.htm'
  url 'http://www.orientechnologies.com/download.php?email=unknown@unknown.com&file=orientdb-community-2.0.6.tar.gz&os=mac'
  version '2.0.6'
  sha1 'a2380e7d1f555a2f52e9aa591c74e60d9cc07588'

  bottle do
    cellar :any
    sha256 "6a6a1ac81acb2395ebac70a7dbad009f7b76a6ca08cdae58477b29d6527dbb50" => :yosemite
    sha256 "2d1d145ecd1ba7e56e2a8c9bf0a91890d03b8599bada7cae41681380e4706f2a" => :mavericks
    sha256 "1c8a5f75a37a4fbc5d6173e012add0e79dd7d2061e88a1bb041765f4cb068684" => :mountain_lion
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
