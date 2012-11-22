require 'formula'

class Orientdb < Formula
  homepage 'http://www.orientdb.org/index.htm'
  url 'http://orient.googlecode.com/files/orientdb-graphed-1.2.0.zip'
  sha1 '7b6dc5740510f15150ee5eb457b717ecec468f7e'

  def patches
    # Fixing OrientDB init scripts
    "https://raw.github.com/gist/3965837/b464748b1759117ac5fb2039f54d5a5fd204f0b8/homebrew.patch"
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

  def test
    system "orientdb start"
    system "orientdb status | grep PID"
    system "orientdb stop"
  end
end
