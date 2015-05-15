require 'formula'

class Orientdb < Formula
  homepage 'http://www.orientdb.org/index.htm'
  url 'http://www.orientechnologies.com/download.php?email=unknown@unknown.com&file=orientdb-community-2.0.9.tar.gz&os=mac'
  version '2.0.9'
  sha1 '03637f65a18831a382ca64b87660578f16a3157b'

  bottle do
    cellar :any
    sha256 "6705f71386d9ac0df3b9c36d19396224d8e29ce2cbd007b4f0cbe13d42c50905" => :yosemite
    sha256 "8b70601d73023de3cfdecf50703c829aca579399f9df5b003607f31910bf4bae" => :mavericks
    sha256 "b45214091f8573b4c9d9cda50f5f78cc36a36529a30b63adfb4921b48f88ff99" => :mountain_lion
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
