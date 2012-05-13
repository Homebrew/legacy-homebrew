require 'formula'

class VertX < Formula
  homepage 'http://vertx.io/'
  url 'https://github.com/downloads/purplefox/vert.x/vert.x-1.0.final.tar.gz'
  md5 'ecfaf3a8e2c749e75b6618980255308e'


  def install
      rm_f Dir["bin/*.bat"]
      libexec.install %w[bin client conf lib mods]
      doc.install %w[docs examples]
      prefix.install "LICENSE.txt"
      bin.install_symlink "#{libexec}/bin/vertx"
  end
end
