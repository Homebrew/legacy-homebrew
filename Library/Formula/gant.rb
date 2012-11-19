require 'formula'

class Gant < Formula
  homepage 'http://gant.codehaus.org/'
  url 'http://dist.codehaus.org/gant/distributions/gant-1.9.8-_groovy-2.0.0.tgz'
  version '1.9.8'
  sha1 '995c33754dfdb28f2c7ab1f2c3f6d73db41a5cca'

  depends_on 'groovy'

  def install
    rm_f Dir["bin/*.bat"]
    # gant-starter.conf is found relative to bin
    libexec.install %w[bin lib conf]
    bin.install_symlink "#{libexec}/bin/gant"
  end
end
