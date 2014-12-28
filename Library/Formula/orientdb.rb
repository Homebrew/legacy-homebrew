require 'formula'

class Orientdb < Formula
  homepage 'http://www.orientdb.org/index.htm'
  url 'http://www.orientechnologies.com/download.php?email=unknown@unknown.com&file=orientdb-community-1.7.10.tar.gz&os=mac'
  version '1.7.10'
  sha1 '71c38c2e91ec6e92bf9d6c166af750f491380852'

  devel do
    url 'http://www.orientechnologies.com/download.php?email=unknown@unknown.com&file=orientdb-community-2.0-rc1.tar.gz&os=mac'
    version '2.0-RC1'
    sha1 '882a9502310e91ff026dce15890b4e019aaf9dda'
  end


  bottle do
    cellar :any
    sha1 "ce4b7060fc28b4e686fae9cea7d6c016c988ef57" => :yosemite
    sha1 "a6320a3d1b705aea9bdb5c73f7e15cfeae50b0eb" => :mavericks
    sha1 "e58a8099e08788365b2d8ad4148e6e46ee1021f5" => :mountain_lion
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
