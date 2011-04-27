require 'formula'

class Gant < Formula
  url 'http://dist.codehaus.org/gant/distributions/gant-1.9.4-_groovy-1.8.0.tgz'
  version '1.9.4'
  homepage 'http://gant.codehaus.org/'
  sha1 'cdefba538de14a89400f71fd3273ba4bf8b06641'

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
