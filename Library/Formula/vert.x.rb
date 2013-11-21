require 'formula'

class VertX < Formula
  homepage 'http://vertx.io/'
  url 'http://dl.bintray.com/vertx/downloads/vert.x-2.0.1-final.tar.gz'
  sha1 'c06df5c3a3f9467a5dfaf354d06b2db7361c65fa'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin client conf lib]
    doc.install %w[api-docs]
    bin.install_symlink "#{libexec}/bin/vertx"
  end
end
