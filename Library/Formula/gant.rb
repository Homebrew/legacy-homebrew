require 'formula'

class Gant <Formula
  url 'http://dist.codehaus.org/gant/distributions/gant-1.9.1-_groovy-1.7.0.tgz'
  version '1.9.1'
  homepage 'http://gant.codehaus.org/'
  md5 '646f29f42793520a3702b1f356f5d4a6'

  depends_on 'groovy'

  def install
    rm_f Dir["bin/*.bat"]
    # gant-starter.conf is found relative to bin
    prefix.install %w[bin lib conf]
  end
end
