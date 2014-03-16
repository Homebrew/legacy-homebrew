require 'formula'

class VertX < Formula
  homepage 'http://vertx.io/'
  url 'http://dl.bintray.com/vertx/downloads/vert.x-2.1RC1.tar.gz'
  sha1 'c3dd58f8266470fc17194d4c73993a871f171614'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin client conf lib]
    doc.install %w[api-docs]
    bin.install_symlink "#{libexec}/bin/vertx"
  end
end
