require 'formula'

class Vertx < Formula
  homepage 'http://vertx.io'
  url 'http://dl.bintray.com/vertx/downloads/vert.x-2.0.2-final.tar.gz'
  sha1 'fc8cce1d3fca9eeac90e15e6338f83c01ca1d44a'
  version '2.0.2-final'

  devel do
    url 'http://dl.bintray.com/vertx/downloads/vert.x-2.1M2.tar.gz'
    sha1 'eedfe222212287749b01a3dd53cb8224d896ee1a'
    version '2.1M2'
  end

  def install
    rm Dir['bin/*.bat']
    libexec.install Dir['*']
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/vertx", "version"
  end
end
