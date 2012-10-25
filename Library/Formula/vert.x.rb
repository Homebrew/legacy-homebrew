require 'formula'

class VertX < Formula
  homepage 'http://vertx.io/'
  url 'http://vertx.io/downloads/vert.x-1.3.0.final.tar.gz'
  sha1 '143737e91dcaf85280275241ae1a2d5bc507831a'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin client conf lib examples]
    doc.install %w[api-docs]
    bin.install_symlink "#{libexec}/bin/vertx"
  end
end
