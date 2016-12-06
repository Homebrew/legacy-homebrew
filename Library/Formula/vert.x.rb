require 'formula'

class VertX < Formula
  homepage 'http://vertx.io/'
  url 'http://vertx.io/downloads/vert.x-1.1.0.final.tar.gz'
  md5 '34198d0079c7e3197106903acba4bb2a'


  def install
      rm_f Dir["bin/*.bat"]
      libexec.install %w[bin client conf lib mods]
      doc.install %w[docs examples]
      prefix.install "LICENSE.txt"
      bin.install_symlink "#{libexec}/bin/vertx"
  end
end
