require 'formula'

class Orientdb < Formula
  homepage 'http://www.orientdb.org/index.htm'
  url 'https://orient.googlecode.com/files/orientdb-graphed-1.3.0.tar.gz'
  sha1 '124e37d2994d2908cc36fd036841b53caeed046c'

  # Fixing OrientDB init scripts
  patch do
    url "https://gist.githubusercontent.com/leppert/5468357/raw/f4c926df7c31fe96425f2bf5feb68b52df31ebaf/homebrew.patch"
    sha1 "1ba6c004d0695fde81053ff010f9d78f757f959b"
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
