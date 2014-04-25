require 'formula'

class Orientdb < Formula
  homepage 'http://www.orientdb.org/index.htm'
  url 'http://www.orientdb.org/portal/function/portal/download/unknown@unknown.com/-/-/-/-/-/orientdb-community-1.6.4.zip/false/false'
  sha1 'c2b0056983c8b8f193139eb898ebee0f32efa1c4'
  version '1.6.4'

  # Fixing OrientDB init scripts
  patch do
    url "https://gist.githubusercontent.com/jjl/11273906/raw/0d12bbb036c795267961965789c6bdfa8c568754/homebrew-orientdb.patch"
    sha1 "f4063fe596ab0319b1a7e8af4077926cf3640d88"
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
