require 'formula'

class Orientdb < Formula
  homepage 'http://www.orientdb.org/index.htm'
  url 'http://www.orientdb.org/portal/function/portal/download/unknown@unknown.com/%20/%20/%20/%20/unknown/orientdb-community-1.6.2.tar.gz'
  sha1 'b476960df5006721fbd6e7893139870a32335c9d'

  def patches
    # Fixing OrientDB init scripts
    'https://gist.github.com/asparagui/8056604/raw/2f4614dd40ae933a86c62caf6d2fbd214e2ab836/homebrew.patch'
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

  test do
    system "#{bin}/orientdb", "start"
    system "#{bin}/orientdb status | grep PID"
    system "#{bin}/orientdb", "stop"
  end
end
