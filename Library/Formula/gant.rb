require 'formula'

class Gant < Formula
  homepage 'http://gant.codehaus.org/'
  url 'http://dist.codehaus.org/gant/distributions/gant-1.9.5-_groovy-1.8.0.tgz'
  version '1.9.5'
  sha1 'd29d228fdeef3479d6ea11b6af3275f647e864e3'

  depends_on 'groovy'

  def install
    rm_f Dir["bin/*.bat"]
    # gant-starter.conf is found relative to bin
    libexec.install %w[bin lib conf]
    bin.install_symlink "#{libexec}/bin/gant"
  end
end
