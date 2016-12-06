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

    libexec.install Dir['*']
    mkpath "#{libexec}/log"
    touch "#{libexec}/log/orientdb.err"
    touch "#{libexec}/log/orientdb.log"

    customize_script_with_path "#{libexec}/bin/orientdb.sh"
    customize_script_with_path "#{libexec}/bin/console.sh"
    customize_script_with_path "#{libexec}/bin/gremlin.sh"

    bin.mkpath
    Dir["#{libexec}/bin/*"].each { |file| chmod 0755, file }

    bin.install "#{libexec}/bin/orientdb.sh" => 'orientdb'
    bin.install "#{libexec}/bin/console.sh" => 'orientdb-console'
    bin.install "#{libexec}/bin/gremlin.sh" => 'orientdb-gremlin'
  end

  def caveats
    "Use `orientdb <start | stop | status>`, `orientdb-console` and `orientdb-gremlin`."
  end

  def test
    # system <<-TEST.undent
    #   echo `orientdb-console <<EOS
    #   exit
    #   EOS` | grep -Po 'OrientDB console v\\.\\d\\.\\d+rc\\d+'
    # TEST

    system "orientdb start"
    system "orientdb status | grep PID"
    system "orientdb stop"
  end

  def customize_script_with_path(script_path)
    init = File.read(script_path)
    init.sub!('"YOUR_ORIENTDB_INSTALLATION_PATH"', libexec)
    File.open(script_path, 'w') { |file| file.write init }
  end
end
