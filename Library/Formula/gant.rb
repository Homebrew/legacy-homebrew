require 'formula'

class Gant < Formula
  url 'http://dist.codehaus.org/gant/distributions/gant-1.9.5-_groovy-1.8.0.tgz'
  version '1.9.5'
  homepage 'http://gant.codehaus.org/'
  md5 '2ea01f1a4c803fd88e15fe2d8290e969'

  depends_on 'groovy'

  def install
    rm_f Dir["bin/*.bat"]
    # gant-starter.conf is found relative to bin
    libexec.install %w[bin lib conf]
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |f|
      next unless File.extname(f).empty?
      ln_s f, bin+File.basename(f)
    end
  end
end
