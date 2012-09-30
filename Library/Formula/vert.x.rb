require 'formula'

class VertX < Formula
  homepage 'http://vertx.io/'
  url 'http://vertx.io/downloads/vert.x-1.2.3.final.tar.gz.html'
  sha1 '11555bf76162a144063422e38c8d16eb8ea6913e'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin client conf lib mods]
    doc.install %w[docs examples]
    bin.install_symlink "#{libexec}/bin/vertx"
  end
end
