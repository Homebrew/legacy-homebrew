require 'formula'

class VertX < Formula
  homepage 'http://vertx.io/'
  url 'http://vertx.io/downloads/vert.x-1.3.1.final.tar.gz'
  version '1.3.1'
  sha1 '734358191245baf63047264008867e69e7d56bed'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin client conf lib examples]
    doc.install %w[api-docs]
    bin.install_symlink "#{libexec}/bin/vertx"
  end
end
