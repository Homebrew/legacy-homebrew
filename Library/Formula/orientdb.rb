require 'formula'

class Orientdb < Formula
  homepage 'http://www.orientdb.org/index.htm'
  url 'http://www.orientdb.org/portal/function/portal/download/unknown@unknown.com/-/-/-/-/-/orientdb-community-1.7.9.tar.gz/false/false/mac'
  version '1.7.9'
  sha1 '85e6e13bde4e04fb66828faf2bee6462a4b39f1e'

  bottle do
    cellar :any
    sha1 "0bc1553a143ad95dbb32eca2f17eb79c38ac50c5" => :mavericks
    sha1 "3d249cb0d2559f3fdf31e9aec9d1b9ee6119a306" => :mountain_lion
    sha1 "2765f099266ccc4a1b2ccd5240343cb72282c3ee" => :lion
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
