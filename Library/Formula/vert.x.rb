require 'formula'

class VertX < Formula
  homepage 'http://vertx.io/'
  url 'http://vertx.io/downloads/vert.x-1.2.3.final.tar.gz'
  sha1 'ed1b3334ac80b3e73079d2d34edb170789163e7d'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin client conf lib examples]
    doc.install %w[api-docs]
    bin.install_symlink "#{libexec}/bin/vertx"
  end
end
