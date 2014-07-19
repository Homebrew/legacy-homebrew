require 'formula'

class Orientdb < Formula
  homepage 'http://www.orientdb.org/index.htm'
  url 'http://www.orientdb.org/portal/function/portal/download/unknown@unknown.com/-/-/-/-/-/orientdb-community-1.7.5.tar.gz/false/false/mac'
  version '1.7.5'
  sha1 '203b31e2615ccedd5c1454a1859ab02cb2f68e1d'

  bottle do
    cellar :any
    sha1 "60c38f94d86882b43788c4c1309ca17f7731c474" => :mavericks
    sha1 "0f06b522b9a4f9d637beb03d5ac100124dc167ea" => :mountain_lion
    sha1 "8dfdcc1085c0a3b778728ac0e0d6bac541684b73" => :lion
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
