require 'formula'

class VertX < Formula
  homepage 'http://vertx.io/'
  url 'http://dl.bintray.com/vertx/downloads/vert.x-2.1.1.tar.gz'
  sha1 'b11d13e641e8115a8ffeff758626e950382d1a2d'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin client conf lib]
    doc.install %w[api-docs]
    bin.install_symlink "#{libexec}/bin/vertx"
  end
end
